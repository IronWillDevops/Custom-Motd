#!/bin/bash
NORMAL='\033[37m'
RED='\033[0;31m'
GREEN='\033[0;32m'

ShowError() {
   echo -e "[ ${RED}Error${NORMAL} ] - $1"
}
ShowMessage() {
   echo -e  "$1"
}

ShowInfo() 
{
   echo -e "[ ${GREEN}$(date +%T)${NORMAL} ] - $1"
}

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
	ShowError 'This installer needs to be run with "bash", not "sh".'
	exit
fi

# Discard stdin. Needed when running from an one-liner which includes a newline
read -N 999999 -t 0.001

# Check the script is not being run by root
if [ "$(id -u)" != "0" ]; then
   ShowError "This script must not be run as root"
   exit 1
fi 


PathToBackup=/etc/update-motd.d/backup/

StartInstall() 
{ 
    defaultMOTD=/etc/update-motd.d/

    ShowInfo "Start of installation"
# Check if the backup folder exists
    if [ ! -d "$PathToBackup" ];then
       ShowInfo "Create folder: $PathToBackup"
       sudo mkdir $PathToBackup
    fi
# Make a backup copy of MOTD to the /$PathToBackup folder
    ShowInfo "Backup started"
    for file in $(ls $defaultMOTD); do
        if [  "$defaultMOTD$file/" != "$PathToBackup" ];then
            sudo mv  $defaultMOTD$file $PathToBackup
            ShowInfo "File: $defaultMOTD$file ${GREEN}copied to$NORMAL $PathToBackup$file"

        else
            ShowError "File: $defaultMOTD$file - ${RED}skipped${NORMAL}  cannot copy a directory, '$defaultMOTD$file/', into itself, '$PathToBackup'"
        fi

    done

    ShowInfo "Backup completed"
}
MakeChoice()
{
    ShowMessage "Custom-MOTD has been installed!"
    ShowMessage ""
    ShowMessage "Select an option:"
    ShowMessage "    1. Install"
    ShowMessage "    0. Exit"

    read -p "Select an option [1]: " option
	until [[ -z "$option" || "$option" =~ ^[0-2]$ ]]; do
		echo "$option: invalid selection."
                read -p "Select an option [1]: " option
	done
    case "$option" in
        1|"")
            StartInstall
        ;;
        0)
            ShowMessage "Abort!"
            exit 1;
        ;;
    esac
}


#Check installed
PathAPP=/etc/Custom-Motd
if [ -d "$PathAPP" ];then
# Make choise
   MakeChoice
else
# Install
   StartInstall
fi
