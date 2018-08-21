#!/bin/bash
# -----------------------------------------------------------------------------
# EFI mode check for Extension Attribute
# Last Edited: 8/21/18
# -----------------------------------------------------------------------------

# check for the presence of an EFI firmware password
checkPass="$(/usr/sbin/firmwarepasswd -check | awk '/Password/ {print $(3) }')"

# if "Yes", there is a firmware password, otherwise there is not
if [ "$checkPass" == "Yes" ] ; then
    echo "<result>Enabled</result>"
else
    echo "<result>None</result>"
fi
exit
# -----------------------------------------------------------------------------
