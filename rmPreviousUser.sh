#!/bin/bash
# -----------------------------------------------------------------------------
# rmPreviousUser.sh
# Script to remove the student user acount from a device instead of reimaging
# Last Edited: 6/15/18
# -----------------------------------------------------------------------------
# variables
adminUser=""     # $4 parameter
adminUser2=""    # $5 parameter

# -----------------------------------------------------------------------------
# clean up /tmp
rm /tmp/*.txt

# check for username parameter $4 from JSS policy
if [ "$4" != "" ] ; then
    adminUser="$4"
else
    echo "Parameter 4 not specified in the JSS"
    exit
fi
# check for username parameter $5 from JSS policy
if [ "$5" != "" ] ; then
    adminUser2="$5"
else
    echo "Parameter 5 not specified in the JSS"
    exit
fi

# move into /Users to collect usernames above UID 500
cd /Users
echo "$(ls -1)" >> /tmp/Users.txt

# read usernames find user that is not Guest, Shared, or the adminUser
userDelete="$(grep -v -e "$adminUser" -e "$adminUser2" -e "Guest" -e "Shared" /tmp/Users.txt)"
# check that $userDelete is not blank, otherwise, /Users will be deleted
if [ "$userDelete" != "" ] ; then
    echo "Removing /Users/$userDelete"
    rm -rf "$userDelete"
    echo "Removing user $userDelete"
    dscl . -delete "/Users/$userDelete"
    exit
else
    echo "userDelete = $userDelete"
    exit
fi
# -----------------------------------------------------------------------------
