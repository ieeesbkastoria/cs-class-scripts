#!/bin/bash

# Color variables for better readability in output
endColor="\e[0m"
redColor="\e[31m"
greenColor="\e[32m"
yellowColor="\e[33m"

# Tools for each edition
declare -a HOME_TOOLS=("curl" "wget")          # Tools for the Home Edition
declare -a SECURITY_TOOLS=("nmap" "wireshark") # Tools for the Security Edition

# Function to ensure a package is installed
ensure_package_installed() {
    local package=$1
    echo -e "${yellowColor}Checking if $package is installed...${endColor}"
    if ! dpkg -l | grep -q "^ii  $package "; then
        echo -e "${redColor}$package is not installed. Installing...${endColor}"
        apt-get install -y "$package"
        if [ $? -eq 0 ]; then
            echo -e "${greenColor}$package installed successfully.${endColor}"
        else
            echo -e "${redColor}Failed to install $package. Exiting.${endColor}"
            exit 1
        fi
    else
        echo -e "${greenColor}$package is already installed.${endColor}"
    fi
}

# Function to validate APT repository configuration
validate_apt_sources() {
    echo -e "${yellowColor}Validating APT repository configuration...${endColor}"
    if ! grep -q "deb https://deb.parrot.sh/parrot" /etc/apt/sources.list; then
        echo -e "${redColor}ParrotSec APT repository is missing. Adding it now...${endColor}"
        echo "deb https://deb.parrot.sh/parrot lory main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
    else
        echo -e "${greenColor}ParrotSec APT repository is configured correctly.${endColor}"
    fi
}

# Function to validate security repository configuration
validate_security_repo() {
    echo -e "${yellowColor}Validating security repository configuration...${endColor}"
    if ! grep -q "deb https://deb.parrot.sh/direct/parrot lory-security" /etc/apt/sources.list; then
        echo -e "${redColor}Security repository is missing. Adding it now...${endColor}"
        echo "deb https://deb.parrot.sh/direct/parrot lory-security main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
    else
        echo -e "${greenColor}Security repository is configured correctly.${endColor}"
    fi
}

# Function to install tools based on edition
install_tools() {
    local edition=$1
    echo -e "${yellowColor}Installing tools for the $edition edition...${endColor}"

    if [ "$edition" == "home" ]; then
        for tool in "${HOME_TOOLS[@]}"; do
            ensure_package_installed "$tool"
        done
    elif [ "$edition" == "security" ]; then
        for tool in "${SECURITY_TOOLS[@]}"; do
            ensure_package_installed "$tool"
        done
    else
        echo -e "${redColor}Unknown edition: $edition. Valid options are 'home' or 'security'.${endColor}"
        exit 1
    fi

    echo -e "${greenColor}All tools for the $edition edition are installed.${endColor}"
}

# Main function to validate the environment and install tools
main() {
    if [ $# -ne 1 ]; then
        echo -e "${redColor}Usage: $0 <home|security>${endColor}"
        echo "Example: $0 home"
        echo "         $0 security"
        exit 1
    fi

    local edition=$1

    # Validate environment
    validate_apt_sources
    validate_security_repo

    # Install tools for the selected edition
    install_tools "$edition"
}

# Run the main function
main "$@"




