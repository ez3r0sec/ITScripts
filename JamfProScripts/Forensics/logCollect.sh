#!/bin/bash
# -----------------------------------------------------------------------------
# logCollect.sh
# collect macOS Logs for analysis
# Last Edited: 6/15/18
# -----------------------------------------------------------------------------
# global variables
starDate="$(date +%Y-%m-%d)"
serial="$(/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Serial\ Number\ \(system\)/ {print $NF}')"
logCollectDir="/tmp/$serial-$starDate"
smbShare="/Volumes/LogCollect"
dest1="$smbShare/$serial-$starDate"

# -----------------------------------------------------------------------------
# make directory to store collected logs
if [ -d "$logCollectDir" ] ; then
    rm -rf "$logCollectDir"
else
    mkdir "$logCollectDir"
fi

# collect Logs
rsync -var /Library/Logs/ "$logCollectDir/LibLogs"
rsync -var /private/var/log/ "$logCollectDir/VarLogs"
cp -r ~/Library/Logs/ "$logCollectDir/UserLibLogs"

# open SMB share to copy logs to it
diskutil unmount force "$smbShare"
open "smb://user:password@sharename/LogCollect"
sleep 15
rsync -var "$logCollectDir/" "$dest1"
sleep 5
diskutil unmount force "$smbShare"
# remove logCollectDir
rm -rf "$logCollectDir"
exit
# -----------------------------------------------------------------------------
