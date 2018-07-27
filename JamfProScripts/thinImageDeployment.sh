#!/bin/bash
# -----------------------------------------------------------------------------
# thinImageDeployment.sh
# script for Summer 'reimaging' deployments
# Last Edited: 6/15/18
# -----------------------------------------------------------------------------
### Tasks ###
# set the hostname to serial number
# set the timezone to America/New_York
# enable SSH for inventory collection
# install Google Chrome
# flush previous policy history in the JSS
# run the Apple Software Update binary to get the machine up to date
# tell the machine to trust the JSS (use if you get the profile unverified error)
# run a recon to repopulate the inventory record of the computer in the JSS
# -----------------------------------------------------------------------------
targetUsername=""     # user names for SSH and ARD

if [ "$4" != "" ] ; then
    targetUsername="$4"
else
    exit
fi

if [ "$5" != "" ] ; then
    targetUsername="$5"
else
    exit
fi

# functions -------------------------------------------------------------------
# set Hostname to Serial Number
function setHostname {
    serial="$(/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Serial\ Number\ \(system\)/ {print $NF}')"
    echo "Setting hostname to $serial"
    scutil --set ComputerName $serial
    scutil --set HostName $serial
    scutil --set LocalHostName $serial
}

# set Timezone
function setTime {
    timeZone="America/New_York"
    echo "Setting Timezone to $timeZone"
    /usr/sbin/systemsetup -settimezone "$timeZone"
    /usr/bin/killall SystemUIServer
    echo
}

# enable ssh -- Jamf Software --
# https://www.jamf.com/jamf-nation/third-party-products/files/460/limitsshscope-sh-limit-access-to-ssh-to-a-single-account
function sshCheckEnable {
    sshCheck="$(systemsetup getremotelogin | awk '/Remote/ {print $(3) }')"
    if [ "$sshCheck" == "On" ] ; then
        echo
    elif [ "$sshCheck" == "Off" ] ; then
        userID=`/usr/bin/dscl localhost -read /Local/Default/Users/$targetUsername | grep GeneratedUID | awk '{print $2}'`
        if [ "$userID" != "" ];then
            echo "Granting SSH Access for $targetUsername with GUID $userID"
            /usr/bin/dscl localhost -create /Local/Default/Groups/com.apple.access_ssh
            /usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh GroupMembership "$targetUsername"
            /usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh GroupMembers "$userID"
            /usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh RealName 'Remote Login Group'
            /usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh PrimaryGroupID 104
            systemsetup setremotelogin on
        fi
    else
        exit
    fi
}

# install Google Chrome -- Lewisi Lebentz -- https://lew.im/2017/03/auto-update-chrome/
function installChrome {
    dmgfile="googlechrome.dmg"
    volname="Google Chrome"
    url='https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'
    echo "Installing Google Chrome..."
    /usr/bin/curl -s -o /tmp/$dmgfile $url
    /usr/bin/hdiutil attach /tmp/$dmgfile -nobrowse -quiet
    ditto -rsrc "/Volumes/$volname/Google Chrome.app" "/Applications/Google Chrome.app"
    /usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "$volname" | awk '{print $1}') -quiet
    /bin/rm /tmp/"$dmgfile"
    echo "Google Chrome installed/updated"
}

# Flush previous policies
function flushPrevious {
    jamf flushPolicyHistory
    jamf removeMdmProfile
    jamf manage
    jamf flushCaches
}

# softwareupdate
function softwareUpdates {
    echo "Running system updates"
    softwareupdate -i -a
}

# trust the JSS
function trustJSS {
    jamf trustjss
}

# recon with JSS and shutdown
function reconReboot {
    jamf recon
    echo "Shutting down in 5 seconds"
    sleep 5
    shutdown -r now
}

# -----------------------------------------------------------------------------
flushPrevious
setHostname
setTime
sshCheckEnable
installChrome
softwareUpdates
trustJSS
reconReboot
# -----------------------------------------------------------------------------
