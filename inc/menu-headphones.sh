#!/bin/bash
if [[ $ISSETUP != "Yes" ]]
then
  echo
  echo -e '\e[91mCannot be run directly. Please run setup.sh from AtoMiC ToolKit root folder: \033[0msudo bash setup.sh'
  echo
  exit 0
fi
SUBCHOICE=$(whiptail --title "AtoMiC ToolKit - Manage Headphones" --menu "What would you like to do?" --backtitle "$BACKTITLE" --fb --cancel-button "Back to Main Menu" $LINES $COLUMNS $NETLINES \
"Install" "Install Headphones" \
"Uninstall" "Uninstall Headphones" \
"Backup" "Backup Headphones settings" \
"Restore" "Restore Headphones settings from a previous backup" \
"Manual Update" "Manually update Headphones" \
"Reset Password" "Reset Headphones WebUI password" \
"Access Details" "View Headphones access details" \
"Access Fix" "Make Headphones UI accessible from anywhere" \
"Go Back" "Back to Main Menu" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    #echo "Your chosen option:" $SUBCHOICE
    case "$SUBCHOICE" in 
		"Install" ) source $SCRIPTPATH/headphones/headphones-installer.sh ;;
		"Uninstall" ) source $SCRIPTPATH/headphones/headphones-uninstaller.sh ;;
		"Backup" ) source $SCRIPTPATH/headphones/headphones-backup.sh ;;
		"Restore" ) source $SCRIPTPATH/headphones/headphones-restore.sh ;;
		"Manual Update" ) source $SCRIPTPATH/headphones/headphones-update.sh ;;
        "Reset Password" ) source $SCRIPTPATH/headphones/headphones-reset.sh ;;
        "Access Details" ) source $SCRIPTPATH/headphones/headphones-access.sh ;;
        "Access Fix" ) source $SCRIPTPATH/headphones/headphones-access-fix.sh ;;
		"Go Back" ) source $SCRIPTPATH/inc/menu-main.sh ;;		
		*) source $SCRIPTPATH/inc/invalid-option.sh ;;
	esac
else
    source $SCRIPTPATH/inc/menu-main.sh
fi