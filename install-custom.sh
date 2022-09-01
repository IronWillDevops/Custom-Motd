#!/bin/bash
NORMAL='\033[37m'
RED='\033[0;31m'
GREEN='\033[0;32m'
PathAPP=/etc/Custom-Motd
NameScript=00-Custom-Motd
PathToBackup=/etc/update-motd.d/backup/
defaultMOTD=/etc/update-motd.d/
Sh\owError() {
   echo -e "[ ${RED}Error${NORMAL} ] - $1"
}
ShowMessage() {
   echo -e  "$1"
}

ShowInfo() 
{
   echo -e "[ ${GREEN}$(date +%T)${NORMAL} ] - $1"
}

CheckOrCreatedFolder()
{
 if [ ! -d "$1" ];then
       ShowInfo "Create folder: $1"
       sudo mkdir $1
    else
       ShowInfo "Folder: $1 - ${GREEN}exists${NORMAL}"
    fi

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

StartBackup() {
    ShowInfo "Backup started"
    # Check if the backup folder exists
    CheckOrCreatedFolder "$PathToBackup"
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

StartInstall() {
    ShowInfo "Start of installation"
    StartBackup

  CheckOrCreatedFolder "$PathAPP"
    sudo touch $PathAPP/$NameScript
    ShowInfo "File: $PathAPP/$NameScript - ${GREEN}created${NORMAL}"
    sudo chmod +x $PathAPP/$NameScript    
    ShowInfo  "Setting execution rights"
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
if [ -d "$PathAPP" ];then
# Make choise
   MakeChoice
else
# Install
   StartInstall
fi

