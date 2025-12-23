#!/bin/bash

source scripts/run.sh
source scripts/install_packages.sh

core() {
    local core_packages
    mapfile -t core_packages < config/packages/core.txt

    run "wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg" "Adding VSCodium GPG key"
    run "echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | tee /etc/apt/sources.list.d/vscodium.list" "Adding VSCodium repository"

    run "wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | gpg --dearmor -o /usr/share/keyrings/dbeaver-keyring.gpg" "Adding DBeaver GPG key"
    run "echo 'deb [signed-by=/usr/share/keyrings/dbeaver-keyring.gpg] https://dbeaver.io/debs/dbeaver-ce /' | tee /etc/apt/sources.list.d/dbeaver.list" "Adding DBeaver repository"

    run "apt update" "Updating package lists"
    install_packages "${core_packages[@]}"

    run "apt upgrade -y" "Upgrading packages"
}
