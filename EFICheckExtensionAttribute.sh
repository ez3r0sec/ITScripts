#!/bin/bash
# -----------------------------------------------------------------------------
# EFI mode check for Extension Attribute
# Last Edited: 6/15/17
# -----------------------------------------------------------------------------
# variables
checkPass="$(/usr/sbin/firmwarepasswd -check | awk '/Password/ {print $(3) }')"

# -----------------------------------------------------------------------------
if [ "$checkPass" == "Yes" ] ; then
    echo "<result>Enabled</result>"
else
    echo "<result>None</result>"
fi
exit
# -----------------------------------------------------------------------------
