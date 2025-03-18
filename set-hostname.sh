#!/bin/bash

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_RESET='\033[0m'

handle_result() {
    if [ "$1" -ne 0 ]; then
        printf "${COLOR_RED}[!] Error during step: %s${COLOR_RESET}\n" "$2" >&2
        exit 1
    else
        printf "${COLOR_GREEN}[+] %s: Success${COLOR_RESET}\n" "$2"
    fi
}

header_info() {
    clear
    printf "${COLOR_RED}"
    cat <<"EOF"
███████╗███████╗████████╗    ██╗  ██╗ ██████╗ ███████╗████████╗███╗   ██╗ █████╗ ███╗   ███╗███████╗
██╔════╝██╔════╝╚══██╔══╝    ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝████╗  ██║██╔══██╗████╗ ████║██╔════╝
███████╗█████╗     ██║       ███████║██║   ██║███████╗   ██║   ██╔██╗ ██║███████║██╔████╔██║█████╗  
╚════██║██╔══╝     ██║       ██╔══██║██║   ██║╚════██║   ██║   ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  
███████║███████╗   ██║       ██║  ██║╚██████╔╝███████║   ██║   ██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗
╚══════╝╚══════╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝           
EOF
    printf "${COLOR_RESET}\n"
}


# Display header
header_info

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
    printf "${COLOR_RED}[!] This script must be run as root.${COLOR_RESET}\n" >&2
    exit 1
fi

# Prompt the user to enter the hostname
read -p "Enter the hostname: " hostname

# Check if the user entered a hostname
if [ -z "$hostname" ]; then
    printf "${COLOR_RED}[!] Hostname cannot be empty.${COLOR_RESET}\n" >&2
    exit 1
fi

# Set the hostname
hostnamectl set-hostname "$hostname"
handle_result $? "Setting hostname"

# Verify the hostname was set
current_hostname=$(hostname)
if [ "$current_hostname" == "$hostname" ]; then
    printf "${COLOR_GREEN}[+] Hostname successfully set to %s please reboot${COLOR_RESET}\n" "$hostname"
else
    printf "${COLOR_RED}[!] Failed to set hostname.${COLOR_RESET}\n" >&2
    exit 1
fi