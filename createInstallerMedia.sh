#!/bin/bash
# -----------------------------------------------------------------------------
# createInstallerMedia.sh
# Detect the macOS installer version in /Applications and creates install media
# Last Edited: 6/19/18
# -----------------------------------------------------------------------------
# functions
# check for root privs
function checkPrivs {
    if [ "$(whoami)" != "root" ] ; then
        echo "Script must be run as root or with sudo privileges"
        exit
    fi
}

# ask for the volume title
installerMediaVolume=
function media_volume {
    printf "What is the name of the volume you would like to use for the installer media? -> "
    read A
    installerMediaVolume="$A"
}

# confirm which installer to use
function installer_choose {
    printf "Detected $installerVers installer. Create install media using this installer application? (y/n) -> "
    read A
    if [ "$A" == "y" ] ; then
        # call createinstallmedia
        create_$callFunction
    elif [ "$A" == "n" ] ; then
        printf "Is there another installer application you would like to use? (sierra, elcap, yose, mav) -> "
        read B
        callFunction="$B"
        # call createinstallmedia
        create_$callFunction
    else
        echo "Invalid option"
        installer_choose
    fi
}

##########################################
# build commands
function create_highC {
    /Applications/Install\ macOS\ High\ Sierra.app/Contents/Resources/createinstallmedia --volume /Volumes/$installerMediaVolume --applicationpath /Applications/Install\ macOS\ High\ Sierra.app
}

function create_sierra {
    /Applications/Install\ macOS\ Sierra.app/Contents/Resources/createinstallmedia --volume /Volumes/$installerMediaVolume --applicationpath /Applications/Install\ macOS\ Sierra.app
}

function create_elcap {
    /Applications/Install\ OS\ X\ El\ Capitan.app/Contents/Resources/createinstallmedia --volume /Volumes/$installerMediaVolume --applicationpath /Applications/Install\ OS\ X\ El\ Capitan.app
}

function create_yose {
    /Applications/Install\ OS\ X\ Yosemite.app/Contents/Resources/createinstallmedia --volume /Volumes/$installerMediaVolume --applicationpath /Applications/Install\ OS\ X\ Yosemite.app
}

function create_mav {
    /Applications/Install\ OS\ X\ Mavericks.app/Contents/Resources/createinstallmedia --volume /Volumes/$installerMediaVolume --applicationpath /Applications/Install\ OS\ X\ Mavericks.app
}
##########################################

# check for vers
installerVers=
callFunction=
function installer_detect {
    if [ -d /Applications/Install\ macOS\ High\ Sierra.app ] ; then
        installerVers="High Sierra"
        callFunction="highC"
        echo "Detected $installerVers Installer"
    elif [ -d /Applications/Install\ macOS\ Sierra.app ] ; then
        installerVers="macOS Sierra"
        callFunction="sierra"
        echo "Detected $installerVers Installer"
    elif [ -d /Applications/Install\ OS\ X\ El\ Capitan.app ] ; then
        installerVers="El Capitan"
        callFunction="elcap"
        echo "Detected $installerVers Installer"
    elif [ -d /Applications/Install\ OS\ X\ Yosemite.app ] ; then
        installerVers="Yosemite"
        callFunction="yose"
        echo "Detected $installerVers Installer"
    elif [ -d /Applications/Install\ OS\ X\ Mavericks.app ] ; then
        installerVers="Mavericks"
        callFunction="mav"
        echo "Detected $installerVers Installer"
    else
        echo "No macOS or OS X installer application found, exiting"
        exit
    fi
}
# --------------------------------------
# call functions
checkPrivs
media_volume
installer_detect
installer_choose
exit
# -----------------------------------------------------------------------------
