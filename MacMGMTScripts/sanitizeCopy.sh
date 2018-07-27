#!/bin/bash
# -----------------------------------------------------------------------------
# sanitizeCopy.sh
# Move personal data to external hard drive
# Last Edited: 6/19/18
# -----------------------------------------------------------------------------
# global variables
userName="$(id -un)"
starDate="$(date +%Y-%m-%d)"

# -----------------------------------------------------------------------------
# paths
rm /tmp/paths.txt
cd /Users/$userName
echo "$(ls -1)" >> /tmp/paths.txt

# -----------------------------------------------------------------------------
# functions
function checkPrivs {
    if [ "$(whoami)" != "root" ] ; then
        echo "Script must be run as root or with sudo privileges"
        exit
    fi
}

function removeArchives {
    cat /tmp/paths.txt | while read line
    do
        cd "/Users/$userName/$line"
        rm -f *.dmg
        rm -rf *.zip
        rm -rf *.pkg
        rm -rf *.mpkg
        rm -rf *.app
    done
}

function syncData {
    sudo mkdir "/Volumes/DataRescue1/$userName-$starDate"
    # read lines and rsync each folder into a corresponding folder
    cat /tmp/paths.txt | while read line
    do
        mkdir "/Volumes/DataRescue1/$userName-$starDate/$line"
        rsync -var "/Users/$userName/$line/" "/Volumes/DataRescue1/$userName-$starDate/$line"
    done
}

# -----------------------------------------------------------------------------
checkPrivs
removeArchives
syncData
exit
# -----------------------------------------------------------------------------
