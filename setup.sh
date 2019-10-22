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

# The main runtime. This is where it all comes together.
main() {
    set_pkg_manager
    update_sys
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
    $MGR update -y
    $MGR upgrade -y
}

# Install programs from package repos
install_from_pkg() {
    $MGR
}

# Install zsh and oh-my-zsh (must be run sequentially)
setup_zsh_env() {
    $MGR install zsh
}



main
