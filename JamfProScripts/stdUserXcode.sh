#!/bin/bash
# -----------------------------------------------------------------------------
# stdUserXcode.sh
# Script to allow non-admin users the ability to use Xcode
# Last Edited: 8/21/18
# -----------------------------------------------------------------------------

# accept the xcode license
xcodebuild -license

# enable the Dev tools
DevToolsSecurity -enable

# edit the "developer" group so that all users are members
dseditgroup -o edit -a everyone -t group _developer

# exit
exit
# -----------------------------------------------------------------------------
