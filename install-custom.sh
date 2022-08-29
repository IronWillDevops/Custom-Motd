#!/bin/bash

ShowError() {
   echo  "[\033[31mError\033[37m] - $1"
}
ShowMessage() {
   echo  "$1"
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
}


#Check installed
PathAPP=/etc/
if [ -d "$PathAPP" ];then
# Make choise
   MakeChoice
else
# Install
   echo ''
fi
