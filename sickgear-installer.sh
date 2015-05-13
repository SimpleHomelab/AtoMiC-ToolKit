#!/bin/bash
# Script Name: AtoMiC SickGear Installer
# Author: htpcBeginner
# Publisher: http://www.htpcBeginner.com
# License: MIT License (refer to README.md for more details)
#

# DO NOT EDIT ANYTHING UNLESS YOU KNOW WHAT YOU ARE DOING.
YELLOW='\e[93m'
RED='\e[91m'
ENDCOLOR='\033[0m'
CYAN='\e[96m'
GREEN='\e[92m'
SCRIPTPATH=$(pwd)

function pause(){
   read -p "$*"
}

clear
echo 
echo -e $RED
echo -e " ┬ ┬┬ ┬┬ ┬ ┬ ┬┌┬┐┌─┐┌─┐┌┐ ┌─┐┌─┐┬┌┐┌┌┐┌┌─┐┬─┐ ┌─┐┌─┐┌┬┐"
echo -e " │││││││││ ├─┤ │ ├─┘│  ├┴┐├┤ │ ┬│││││││├┤ ├┬┘ │  │ ││││"
echo -e " └┴┘└┴┘└┴┘o┴ ┴ ┴ ┴  └─┘└─┘└─┘└─┘┴┘└┘┘└┘└─┘┴└─o└─┘└─┘┴ ┴"
echo -e $CYAN
echo -e "                __     __           "
echo -e "  /\ |_ _ |\/|./      (_  _ _. _ |_ "
echo -e " /--\|_(_)|  ||\__    __)(_| ||_)|_ "
echo -e "                              |     "
echo -e $GREEN'AtoMiC SickGear Installer Script'$ENDCOLOR
echo 
echo -e $YELLOW'--->SickGear installation will start soon. Please read the following carefully.'$ENDCOLOR

echo -e '1. The script has been confirmed to work on Ubuntu variants, Mint, and Ubuntu Server.'
echo -e '2. While several testing runs identified no known issues, '$CYAN'www.htpcBeginner.com'$ENDCOLOR' or the authors cannot be held accountable for any problems that might occur due to the script.'
echo -e '3. If you did not run this script with sudo, you maybe asked for your root password during installation.'
echo -e '4. By proceeding you authorize this script to install any relevant packages required to install and configure SickGear.'
echo -e '5. Best used on a clean system (with no previous SickGear install) or after complete removal of previous SickGear installation.'

echo

read -p 'Type y/Y and press [ENTER] to AGREE and continue with the installation or any other key to exit: '
RESP=${REPLY,,}

if [ "$RESP" != "y" ] 
then
	echo -e $RED'So you chickened out. May be you will try again later.'$ENDCOLOR
	echo
	pause 'Press [Enter] key to continue...'
	cd $SCRIPTPATH
	sudo ./setup.sh
	exit 0
fi

echo 

echo -n 'Type the username of the user you want to run SickGear as and press [ENTER]. Typically, this is your system login name (IMPORTANT! Ensure correct spelling and case): '
read UNAME

if [ ! -d "/home/$UNAME" ] || [ -z "$UNAME" ]; then
	echo -e $RED'Bummer! You may not have entered your username correctly. Exiting now. Please rerun script.'$ENDCOLOR
	echo
	pause 'Press [Enter] key to continue...'
	cd $SCRIPTPATH
	sudo ./setup.sh
	exit 0
fi
UGROUP=($(id -gn $UNAME))

echo

echo -e $YELLOW'--->Refreshing packages list...'$ENDCOLOR
sudo apt-get update

echo
sleep 1

echo -e $YELLOW'--->Installing prerequisites...'$ENDCOLOR
sudo apt-get -y install git-core python python-cheetah

echo
sleep 1

echo -e $YELLOW'--->Checking for previous versions of SickGear...'$ENDCOLOR
sleep 1
sudo /etc/init.d/sickgear stop >/dev/null 2>&1
echo -e 'Any running SickGear processes stopped'
sleep 1
sudo update-rc.d -f sickgear remove >/dev/null 2>&1
sudo rm /etc/init.d/sickgear >/dev/null 2>&1
sudo rm /etc/default/sickgear >/dev/null 2>&1
echo -e 'Existing SickGear init scripts removed'
sleep 1
sudo update-rc.d -f sickgear remove >/dev/null 2>&1
if [ -d "/home/$UNAME/.sickgear" ]; then
	mv /home/$UNAME/.sickgear /home/$UNAME/.sickrage_`date '+%m-%d-%Y_%H-%M'` >/dev/null 2>&1
	echo -e 'Existing SickGear files were moved to '$CYAN'/home/'$UNAME'/.sickrage_'`date '+%m-%d-%Y_%H-%M'`$ENDCOLOR
fi

echo
sleep 1

echo -e $YELLOW'--->Downloading latest SickGear...'$ENDCOLOR
cd /home/$UNAME
git clone https://github.com/SickGear/SickGear /home/$UNAME/.sickgear || { echo -e $RED'Git not found.'$ENDCOLOR ; exit 1; }
sudo chown -R $UNAME:$UGROUP /home/$UNAME/.sickgear >/dev/null 2>&1
sudo chmod 775 -R /home/$UNAME/.sickgear >/dev/null 2>&1

echo
sleep 1

echo -e $YELLOW'--->Installing SickGear...'$ENDCOLOR
cd /home/$UNAME/.sickgear
cp -a autoProcessTV/autoProcessTV.cfg.sample autoProcessTV/autoProcessTV.cfg || { echo -e $RED'Could not copy autoProcess.cfg.'$ENDCOLOR ; exit 1; }

echo
sleep 1

echo -e $YELLOW'--->Configuring SickGear Install...'$ENDCOLOR
echo "# COPY THIS FILE TO /etc/default/sickgear" >> sickrage_default || { echo -e $RED'Could not create default file.'$ENDCOLOR ; exit 1; }
echo "SB_HOME=/home/"$UNAME"/.sickgear/" >> sickrage_default
echo "SB_DATA=/home/"$UNAME"/.sickgear/" >> sickrage_default
echo -e 'Enabling user'$CYAN $UNAME $ENDCOLOR'to run SickGear...'
echo "SB_USER="$UNAME >> sickrage_default
sudo mv sickrage_default /etc/default/sickgear
sudo chmod +x /etc/default/sickgear

echo
sleep 1

echo -e $YELLOW'--->Enabling SickGear AutoStart at Boot...'$ENDCOLOR
sudo cp runscripts/init.ubuntu /etc/init.d/sickgear || { echo -e $RED'Creating init file failed.'$ENDCOLOR ; exit 1; }
sudo chown $UNAME: /etc/init.d/sickgear
sudo sed -i 's|/etc/default/sickbeard|/etc/default/sickgear|g' /etc/init.d/sickgear || { echo -e $RED'Replacing default path failed.'$ENDCOLOR ; exit 1; }
sudo sed -i 's|NAME=sickbeard|NAME=sickgear|g' /etc/init.d/sickgear || { echo -e $RED'Replacing NAME failed.'$ENDCOLOR ; exit 1; }
sudo sed -i 's|DESC=SickBeard|DESC=SickGear|g' /etc/init.d/sickgear || { echo -e $RED'Replacing DESC failed.'$ENDCOLOR ; exit 1; }

sudo chmod +x /etc/init.d/sickgear
sudo update-rc.d sickgear defaults

echo
sleep 1

echo -e $YELLOW'--->Creating Run Directories...'$ENDCOLOR

sudo mkdir /var/run/sickgear >/dev/null 2>&1
sudo chown $UNAME: /var/run/sickgear >/dev/null 2>&1

echo
sleep 1
/etc/init.d/sickgear start

echo
echo -e $GREEN'--->All done. '$ENDCOLOR
echo -e 'SickGear should start within 10-20 seconds and your browser should open.'
echo -e 'If not you can start it using '$CYAN'/etc/init.d/sickgear start'$ENDCOLOR' command.'
echo -e 'Then open '$CYAN'http://localhost:8081'$ENDCOLOR' in your browser.'
echo
echo -e $YELLOW'If this script worked for you, please visit '$CYAN'http://www.htpcBeginner.com'$YELLOW' and like/follow us.'$ENDCOLOR
echo -e $YELLOW'Thank you for using the AtoMiC SickGear Install script from www.htpcBeginner.com.'$ENDCOLOR 
echo

pause 'Press [Enter] key to continue...'

cd $SCRIPTPATH
sudo ./setup.sh
exit 0
