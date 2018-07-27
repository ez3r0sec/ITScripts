#!/bin/bash
# -----------------------------------------------------------------------------
# rmGoogleDrive.app
# Script to uninstall components of the Google Drive Desktop client for Mac
# Last Edited: 6/19/18
# -----------------------------------------------------------------------------
# variables
userName="$(id -un)"

# -----------------------------------------------------------------------------
if [ "$(whoami)" != "root" ] ; then
    echo "Script must be run as root or with sudo privileges"
    exit
fi

# check for the .app, if no, check if user wants to uninstall supporting files only
if [ -d "/Applications/Google Drive.app" ] ; then
    echo "* * * * * * * Uninstall Google Drive * * * * * * *"
    echo "Removing Google Drive.app..."
    rm -rf "/Applications/Google Drive.app"
    echo "Removing supporting files..."
    rm -rf "/Users/$userName/Library/Application Support/Google/Drive"
    rm -rf "/Users/$userName/Library/Caches/com.google.GoogleDrive.FinderSyncAPIExtension"
    rm -rf "/Users/$userName/Library/Containers/com.google.GoogleDrive.FinderSyncAPIExtension"
    rm -rf "/Users/$userName/Library/Preferences/com.google.GoogleDrive.plist"
    rm -rf "/Users/$userName/Library/Cookies/com.google.GoogleDrive.binarycookies"
    rm -rf "/Users/$userName/Library/Google/GoogleSoftwareUpdate/Actives/com.google.GoogleDrive"
    rm -rf "/Users/$userName/Library/Group Containers/google_drive"
    rm -rf "/Users/$userName/Library/Application Scripts/com.google.GoogleDrive.FinderSyncAPIExtension"
    echo "Uninstall complete"
    exit
else 
    echo "* * * * * * * Uninstall Google Drive * * * * * * *"
    printf "Uninstall hidden files only? (y/n) -> "
    read A
    if [ "$A" == "y" ] ; then
        echo "Removing supporting files..."
        rm -rf "/Users/$userName/Library/Application Support/Google/Drive"
        rm -rf "/Users/$userName/Library/Caches/com.google.GoogleDrive.FinderSyncAPIExtension"
        rm -rf "/Users/$userName/Library/Containers/com.google.GoogleDrive.FinderSyncAPIExtension"
        rm -rf "/Users/$userName/Library/Preferences/com.google.GoogleDrive.plist"
        rm -rf "/Users/$userName/Library/Cookies/com.google.GoogleDrive.binarycookies"
        rm -rf "/Users/$userName/Library/Google/GoogleSoftwareUpdate/Actives/com.google.GoogleDrive"
        rm -rf "/Users/$userName/Library/Group Containers/google_drive"
        echo "Uninstall complete"
    else
        echo "Exiting..."
    fi  
fi
exit
# -----------------------------------------------------------------------------
