#!/bin/bash
# -----------------------------------------------------------------------------
# VboxManage to startup VBox VMs automatically upon login
# change name to "discoverStartupVMs" and add the file to login items
# Last Edited: 12/17/17
# -----------------------------------------------------------------------------
# Based on the following Command
# VBoxManage startvm <UUID|vmname> --type gui|headless|separate
# -----------------------------------------------------------------------------
# variables
userName="$(id -un)"     # server admin user
machineFolder="/Users/$userName/VirtualBox VMs"    # default VM Folder location
# -----------------------------------------------------------------------------
# discover names of all VMs on a system
cd "$machineFolder"
ls -1 > /tmp/vms.txt
# read machine names from .txt file and feed into VboxManage startvm command
cat /tmp/vms.txt | while read line
do
    vmName="$line"
    VBoxManage startvm "$vmName" --type headless
done
exit
# -----------------------------------------------------------------------------
