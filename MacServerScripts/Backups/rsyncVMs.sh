#!/bin/bash
# -----------------------------------------------------------------------------
# rsyncVms.sh
# Script to backup VMs to Data Partition/Disk for backup by cron
# Last Edited: 6/19/18
# -----------------------------------------------------------------------------
# hardcode server admin user
adminUser=""

# default directory for VM data
vmDir="/Users/$adminUser/VirtualBox VMs"

# file that lists vms
vmListDir="/tmp/vms.txt"

# hardcode backup destination
DEST1="/Volumes/..."

# Script Contents -------------------------------------------------------------
if [ "$(whoami)" != "root" ] ; then
    echo "Script must be run as root or with sudo privileges"
    exit
fi

# navigate to VM machine folder
if [ -f "$vmListDir"] ; then
    cat /tmp/vms.txt | while read line
    do
        rsync -var "" "$DEST"
    done
else
    cd "$vmDir"
    ls -1 >> /tmp/vms.txt     # collect names from directory
    # read machine names from .txt file
    cat /tmp/vms.txt | while read line
    do
        # rsync (verbose, archive, recursively)
        rsync -var "$vmDir/$line/" "$DEST"
    done
fi
exit
# -----------------------------------------------------------------------------
