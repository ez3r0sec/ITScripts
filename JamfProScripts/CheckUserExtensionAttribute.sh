#!/bin/bash
# -----------------------------------------------------------------------------
# check if there is a specific non-hidden user on the computer
# Last Edited: 4/7/7/17
# -----------------------------------------------------------------------------
# variables
targetUser=""     # set target user shortname here

userName1="$(dscl . list /Users UniqueID | awk '$2 == 501 {print $1}')"     # Lists 501 user
userName2="$(dscl . list /Users UniqueID | awk '$2 == 502 {print $1}')"
userName3="$(dscl . list /Users UniqueID | awk '$2 == 503 {print $1}')"
userName4="$(dscl . list /Users UniqueID | awk '$2 == 504 {print $1}')"
userName5="$(dscl . list /Users UniqueID | awk '$2 == 505 {print $1}')"

# -----------------------------------------------------------------------------
echo "$userName1" >> /tmp/Userlist.txt
echo "$userName2" >> /tmp/Userlist.txt
echo "$userName3" >> /tmp/Userlist.txt
echo "$userName4" >> /tmp/Userlist.txt
echo "$userName5" >> /tmp/Userlist.txt

cat /tmp/Userlist.txt | while read line
do
    if [ "$line" == "$targetUser" ] ; then
        echo "<result>Found</result>"
    elif [ "$line" != "$targetUser" ] ; then
        placeholder=0
    else
        echo "<result>None</result>"
    fi
done
exit
# -----------------------------------------------------------------------------
