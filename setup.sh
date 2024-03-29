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
    echo "[*] Bootsrapping system"
    set_pkg_manager
    update_sys
    install_base
    install_from_pkg &
    install_from_pip &
    install_omzsh    &
    wait
    setup_env        
    echo "[*] Bootstrap complete"
}

# Determine and set the package manager for the system.
set_pkg_manager() {
    declare -A sys_to_pkg=(
        ["suse"]="zypper"
        ["debian"]="apt"
        ["fedora"]="dnf"
        ["redhat"]="dnf"
        ["archlinux"]="pacman"
    )

    SYS=$(cat /etc/*-release)

    case $SYS in
        *"suse"*)
            MGR="sudo ${sys_to_pkg["suse"]}"
            ;;
        *"debian"*)
            MGR="sudo ${sys_to_pkg["debian"]}"
            ;;
        *"fedora"*)
            MGR="sudo ${sys_to_pkg["fedora"]}"
            ;;
        *"redhat"*)
            MGR="sudo ${sys_to_pkg["redhat"]}"
            ;;
        *"archlinux"*)
            MGR="sudo ${sys_to_pkg["archlinux"]}"
            ;;
        *)
            return -1 # error code, couldn't determine the base OS
            ;;
    esac

    return 0 # indicate success
}

# Update and upgrade the system, if necessary
update_sys() {
    echo "[*] Updating system"
    $MGR update  -y
    $MGR upgrade -y
    echo "[*] System updates complete"

    return 0 # indicate success
}

# Install some base package dependencies 
install_base() {
    echo "[*] Installing base packages"
    $MGR install zsh         -y
    $MGR install git         -y
    $MGR install npm         -y
    $MGR install curl        -y
    $MGR install python3     -y
    $MGR install neovim      -y
    $MGR install python3-pip -y
    echo "[*] Base package installation complete"

    return 0 # indicate success
}

# Install packages from the distro repositories
install_from_pkg() {
    echo "[*] Installing packages from distro repositories"
    $MGR install qbittorrent  -y
    $MGR install nmap         -y
    $MGR install nikto        -y
    $MGR install hashcat      -y
    $MGR install hydra        -y
    $MGR install aircrack-ng  -y
    echo "[*] Repository package installation complete"

    return 0 # indicate success
}

# Install packages from pip
install_from_pip() {
    prog="--progress-bar pretty"
    pip3 install --user h8mail $prog
    pip3 install --user sqlmap $prog
    pip3 install --user pynvim $prog

    return 0 # indicate success
}

# Build and install applications from source code
install_from_src() {
    return 0 # indicate success
}

# Install Oh My zsh
install_omzsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 

    return 0 # indicate success
}

# Configure zsh and neovim development environment
setup_env() {
    echo "[*] Setting up environment"

    # Move our init file to the correct location
    mkdir -p ~/.config/nvim/
    cp init.vim ~/.config/nvim/

    # update nvim plugins
    nvim -c 'PlugInstall | q'

    # update our Coc lanuage server extensions
    nvim -c 'CocInstall -sync coc-go       | q'
    nvim -c 'CocInstall -sync coc-sh       | q'
    nvim -c 'CocInstall -sync coc-sql      | q'
    nvim -c 'CocInstall -sync coc-css      | q'
    nvim -c 'CocInstall -sync coc-ccls     | q'
    nvim -c 'CocInstall -sync coc-java     | q'
    nvim -c 'CocInstall -sync coc-json     | q'
    nvim -c 'CocInstall -sync coc-html     | q'
    nvim -c 'CocInstall -sync coc-python   | q'
    nvim -c 'CocInstall -sync coc-terminal | q'

    echo "[*] Environment setup complete"

    return 0 # indicate success
}

main

