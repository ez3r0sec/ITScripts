#!/bin/bash
# -----------------------------------------------------------------------------
# checkWhichAdminUser.sh
# check if computer has one of two possible company admin accounts due to manual
# errors during initial setup - very specific use-case
# Last Edited: 6/15/18
# -----------------------------------------------------------------------------
# hardcode each admin account here
adminUser=""
adminUser2=""

# Script Contents -------------------------------------------------------------
# move into /Users to collect the users of the machine
cd /Users
echo "$(ls -l | awk '/drwx/ {print $9}')" > /tmp/Users.txt

# check which users are on the machine
cat /tmp/Users.txt | while read line
do
    if [ "$line" == "Guest" ] ; then
        touch /tmp/$line.txt
    elif [ "$line" == "Shared" ] ; then
        touch /tmp/$line.txt
    elif [ "$line" == "$adminUser" ] ; then
        touch /tmp/$line.txt
    elif [ "$line" == "$adminUser2" ] ; then
        touch /tmp/$line.txt
    else
        touch /tmp/$line.txt
    fi
done

# check for presence of /tmp/$adminUser.txt or /tmp/$adminUser2.txt
if [ -f "/tmp/$adminUser.txt" ] ; then
    echo "<result>$adminUser</result>"
elif [ -f "/tmp/$adminUser2.txt" ] ; then
    echo "<result>$adminUser2</result>"
else
    echo "<result>Neither</result>"
    exit
fi
exit
# -----------------------------------------------------------------------------
