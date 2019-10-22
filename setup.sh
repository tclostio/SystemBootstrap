#!/bin/bash

#################################################
#                                               #
# I like my Linux like I like my beer. Free.    #
#                                               #
# This is designed to be a general, portable,   #
# maintainable, and above all convenient way    #
# to bootstrap a good 'lil hacking/devving      #
# system. Most always, I will be using this     #
# to boostrap Kali VMs for hackery and other    #
# exploits, but it should work (in theory) on   #
# any Linux system with Bash installed*.        #
#                                               #
# Send compliments to spacekek@protonmail.com   #
#                                               #
#                                               #
# *Gentoo is not currently supported, Arch is   #
# buggy and probably broken.                    #
#                                               #
#################################################

# Globals
SYS=""
MGR=""

# loading bar vars
LD_1="->             ()\r"
LD_2="--->           ()\r"
LD_3="----->         ()\r"
LD_4="------->       ()\r"
LD_5="--------->     ()\r"
LD_6="----------->   ()\r"
LD_7="-------------> ()\r"
LD_8="---------------(*)\r"
DONE="\n"

# The main runtime. This is where it all comes together.
main() {
    set_pkg_manager
    update_sys
    install_base
    install_from_pkg
}

# Determine and set the package manager for the system.
set_pkg_manager() {
    declare -A sys_to_pkg=(
        ["debian"]="apt"
        ["fedora"]="dnf"
        ["redhat"]="dnf"
        ["archlinux"]="pacman"
    )

    SYS=$(cat /etc/*-release)

    case $SYS in
        *"debian"*)
            MGR=${sys_to_pkg["debian"]}
            ;;
        *"fedora"*)
            MGR=${sys_to_pkg["fedora"]}
            ;;
        *"redhat"*)
            MGR=${sys_to_pkg["redhat"]}
            ;;
        *"archlinux"*)
            MGR=${sys_to_pkg["archlinux"]}
            ;;
        *)
            return -1 # error code, couldn't determine the base OS
            ;;
    esac
}

# Update and upgrade the system, if necessary
update_sys() {
    echo "[*] Updating system"
    $MGR update -y
    $MGR upgrade -y
    echo "[*] System updates complete"

    return 0 # indicate success
}

# Install some base packages that cannot be run in parallel with the other functions
install_base() {
    echo "[*] Installing base packages"
    $MGR install zsh -y
    $MGR install git -y
    $MGR install curl -y
    $MGR install python3 -y
    $MGR install neovim -y
    $MGR install python3-pip -y
    echo "[*] Base package installation complete"

    return 0 # indicate success
}

install_from_pkg() {
    echo "[*] Installing packages from distro repositories"
    $MGR install qbittorrent -y
    $MGR install nmap -y
    $MGR install nikto -y
    $MGR install sqlmap -y
    $MGR install rxvt-unicode -y
    $MGR install hashcat -y
    $MGR install hydra -y
    $MGR install aircrack-ng -y
    echo "[*] Repository package installation complete"

    return 0 # indicate success
}


main

