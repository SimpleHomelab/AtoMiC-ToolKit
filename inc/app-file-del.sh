#!/bin/bash
echo
sleep 1

echo -e $GREEN'Do you want to keep the following '$APPTITLE' settings / data folder for reinstalling later?'$ENDCOLOR
echo -e 'Folder to be kept: '$CYAN$APPPATH$ENDCOLOR
read -p 'Type y/Y to keep or any other key to delete, and press [ENTER] : '
FILEDEL=${REPLY,,}

if [ "$FILEDEL" != "y" ] 
then
	echo
    if [ -d "$APPPATH" ]; 
	then
		echo -e $YELLOW'--->Deleting '$APPTITLE' files/folders from '$CYAN$APPPATH$YELLOW'...'$ENDCOLOR
		sudo rm -r $APPPATH
    else
    	echo -e $RED'--->'$APPTITLE' files/folders not deleted. Path not found: '$CYAN$APPPATH$ENDCOLOR
    fi
else
	echo
	echo -e $YELLOW'--->Keeping '$APPTITLE' files/folders in '$CYAN$APPPATH$YELLOW'...'$ENDCOLOR
fi
