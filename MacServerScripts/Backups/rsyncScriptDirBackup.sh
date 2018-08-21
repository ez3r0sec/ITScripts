#!/bin/bash
# ---------------------------------------------------------------------
# rsyncScriptDirBackup.sh
# rsync Scripts directory to Google Drive upload folder
# Last Edited: 6/19/18
# ---------------------------------------------------------------------
# admin user of server
adminUser="$(id -un)"

# hostname
hostName="$(hostname)"

# date for stamping logs
starDate="$(date +%Y-%m-%d)"

# Set folders to copy here
SOURCE1="/Scripts"

# Set destination folders
DEST1="/Users/$adminUser/Google Drive/Scripts-$hostName"

# logfile
logFile="/Users/$adminUser/Library/Logs/rsyncScriptDirBackupLog.txt"

# Script Contents
if [ "$(whoami)" != "root" ] ; then
    echo "Script must be run as root or with sudo privileges"
    exit
fi

# create Scripts-$hostName if it does not exist
if [ -d "$DEST1" ] ; then
    # logging - begin entry
    echo "$starDate -- Beginning rsync" >> "$logFile"
    echo "$starDate -- rsync $SOURCE1 to $DEST1" >> "$logFile"
    echo >> "$logFile"
    echo " -- rsync -- " >> "$logFile"
    echo >> "$logFile"
    # rsync (verbose, archive mode, recursively)
    rsync -var "$SOURCE1/" "$DEST1" >> "$logFile"

    # logging - end entry
    echo >> "$logFile"
    echo "$starDate -- Backup complete" >> "$logFile"
    echo >> "$logFile"
    exit
else
    mkdir "$DEST1"
    # logging - begin entry
    echo "$starDate -- Beginning rsync" >> "$logFile"
    echo "$starDate -- rsync $SOURCE1 to $DEST1" >> "$logFile"
    echo >> "$logFile"
    echo " -- rsync -- " >> "$logFile"
    echo >> "$logFile"
    # rsync (verbose, archive mode, recursively)
    rsync -var "$SOURCE1/" "$DEST1" >> "$logFile"

    # logging - end entry
    echo >> "$logFile"
    echo "$starDate -- Backup complete" >> "$logFile"
    echo >> "$logFile"
    exit
fi
exit
# ---------------------------------------------------------------------
