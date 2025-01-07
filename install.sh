#!/bin/bash

source scripts/check_sudo.sh
source scripts/editions/core.sh
source scripts/editions/home.sh
source scripts/editions/security.sh
source scripts/editions/htb.sh
source scripts/editions/headless.sh

# Function to display menu
display_menu() {
    echo "========== ParrotOS Editions Installer =========="
    echo "1) Install Core Edition: Minimal installation for server use."
    echo "2) Install Home Edition: Full desktop environment for daily use."
    echo "3) Install Security Edition: Tools for security testing and auditing."
    echo "4) Install Hack The Box Edition: Customized environment for Hack The Box labs."
    echo "5) Install Headless Edition: Minimal installation without GUI for servers."
    echo "6) Exit"
    echo "================================================="
}

# Check for sudo privileges
check_sudo

# Main installation loop
while true; do
    display_menu
    read -p "Enter the option number: " option
    case $option in
        1) core ;;
        2) core && home ;;
        3) core && security ;;
        4) core && htb ;;
        5) core && headless ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done

