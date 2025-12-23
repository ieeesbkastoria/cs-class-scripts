#!/bin/bash

source scripts/run.sh
source scripts/install_packages.sh

core() {
    local core_packages
    mapfile -t core_packages < config/packages/core.txt

    run "apt update" "Updating package lists"
    install_packages "${core_packages[@]}"
    # run "wget -qO- https://deb.parrotsec.org/parrot/misc/parrotsec.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/parrot-archive-keyring.gpg" "Adding GPG key"
    run "apt update" "Updating package lists"
    run "apt upgrade -y" "Upgrading packages"
}
