#!/bin/bash
# -----------------------------------------------------------------------------
# Check if ARD is enabled
# Last Edited: 4/7/17
# -----------------------------------------------------------------------------
# variables
lineTemplate="com.apple.RemoteDesktop.agent"

# -----------------------------------------------------------------------------
ARD="$(launchctl list | grep '^\d.*RemoteDesktop.*')"
Agent="$(echo $ARD | awk '/com.apple.RemoteDesktop.agent/ {print $(NF) }')"

if [ "$Agent" == "$lineTemplate" ] ; then
    echo "<result>Enabled</result>"
else
    echo "<result>None</result>"
fi
exit
# -----------------------------------------------------------------------------
