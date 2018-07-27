#!/bin/bash
# -----------------------------------------------------------------------------
# logCollectServer.sh
# collect macOS Server Logs for analysis
# Last Edited: 6/19/18
# -----------------------------------------------------------------------------
# global variables
starDate="$(date +%Y-%m-%d)"
nameHost="$(hostname)"
logCollectDir="/tmp/$nameHost-$starDate"
smbShare="/Volumes/LogCollect"
dest1="$smbShare/$nameHost-$starDate"
# -----------------------------------------------------------------------------
function checkPrivs {
    if [ "$(whoami)" != "root" ] ; then
        echo "Script must be run as root or with sudo privileges"
        exit
    fi
}

# make directory to store collected logs
function checkCollection {
    if [ -d "$logCollectDir" ] ; then
        rm -rf "$logCollectDir"
    else
        mkdir "$logCollectDir"
    fi
}

# collect Logs
function logCollect {
    rsync -var /Library/Logs/ "$logCollectDir/LibLogs"
    rsync -var /private/var/log/ "$logCollectDir/VarLogs"
    cp -r ~/Library/Logs/ "$logCollectDir/UserLibLogs"
}

# open SMB share to copy logs to it
function openSMB {
    diskutil unmount force "$smbShare"
    open "smb://user:password@sharename/LogCollect"
    sleep 15
    rsync -var "$logCollectDir/" "$dest1"
    sleep 5
    diskutil unmount force "$smbShare"
    # remove logCollectDir
    rm -rf "$logCollectDir"
}

# script contents -------------------------------------------------------------
checkPrivs
checkCollection
logCollect
openSMB
exit
# -----------------------------------------------------------------------------
