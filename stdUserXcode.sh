#!/bin/bash
# -----------------------------------------------------------------------------
# stdUserXcode.sh
# Script to allow non-admin users the ability to use Xcode
# Last Edited: 6/15/18
# -----------------------------------------------------------------------------

xcodebuild -license
DevToolsSecurity -enable
dseditgroup -o edit -a everyone -t group _developer    # enables all of the computer's users to use xcode
exit
# -----------------------------------------------------------------------------
