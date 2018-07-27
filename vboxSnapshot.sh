#!/bin/bash
# -----------------------------------------------------------------------------
# vboxSnapshot.sh
# Scripted snapshots of VirtualBox VMs on Mac servers using VBoxManage
# Last Edited: 6/19/18
# -----------------------------------------------------------------------------
# variables
# hardcode server admin user
adminUser=""

snapDate="$(date +%m-%d)"
snapShotName="$snapDate"
snapShotDescrption="Snapshot taken on $snapDate by cron"
machineFolder="/Users/$adminUser/VirtualBox VMs"
vmListDir="/tmp/vms.txt"

# Script Contents -------------------------------------------------------------
# if /tmp/vms.txt exists, use contents of file
if [ -f "$vmListDir"] ; then
    # read machine names from .txt file and feed into VboxManage startvm command
    cat /tmp/vms.txt | while read line
    do
        vmName="$line"
        VBoxManage snapshot $vmName take "$snapShotName" --description "$snapShotDescrption"
    done
else     
    # if /tmp/vms.txt does not exist, make it and take snapshots
    cd "$machineFolder"
    ls -1 >> /tmp/vms.txt
    # read machine names from .txt file and feed into VboxManage startvm command
    cat /tmp/vms.txt | while read line
    do
        vmName="$line"
        VBoxManage snapshot $vmName take "$snapShotName" --description "$snapShotDescrption"
    done
fi
exit
# -----------------------------------------------------------------------------
