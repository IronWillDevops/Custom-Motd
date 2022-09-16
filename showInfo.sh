#!/bin/bash
clear
NORMAL='\033[37m'
RED='\033[0;31m'
GREEN='\033[0;32m'
OS=$(uname)
uptime=$(uptime -p)
kernel=$(uname -r)
iplocal=$(hostname -I)
ippublic=$(dig +short myip.opendns.com @resolver1.opendns.com)

echo -e "$(uname -o)"
echo -e "${RED}OS${NORMAL}: $OS"
echo -e "${RED}Uptime${NORMAL}: $uptime"
echo -e "${RED}Kernel${NORMAL}: $kernel"
echo -e "${RED}System load${NORMAL}: $sysload%"
echo -e "${RED}Memory usage${NORMAL}: $memusage%"
echo -e "${RED}Ip-address${NORMAL}: $iplocal"
echo -e "${RED}Public Ip-address${NORMAL}: $ippublic"
echo -e "${RED}Uptime${NORMAL}: $uptime"
echo -e "${RED}Uptime${NORMAL}: $uptime"
echo -e "${RED}Uptime${NORMAL}: $uptime"
echo -e "${RED}Uptime${NORMAL}: $uptime"
echo -e "${RED}Uptime${NORMAL}: $uptime"
echo -e "${RED}Uptime${NORMAL}: $uptime"

