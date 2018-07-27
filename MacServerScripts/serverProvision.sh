#!/bin/bash
# -----------------------------------------------------------------------------
# serverProvision.sh
# Complete some of the provisioning tasks for macOS server
# Last Edited: 6/19/18
# -----------------------------------------------------------------------------
# global variables
# use current user for setup
targetUsername="$(id -un)"

# check if we have adequate privileges
function checkPrivs {
    if [ "$(whoami)" != "root" ] ; then
        echo "Script must be run as root or with sudo privileges"
        exit
    fi
}

# enable SSH ------------------------------------------------------------------
function sshCheckEnable {
    sshCheck="$(systemsetup getremotelogin | awk '/Remote/ {print $(3) }')"
    if [ "$sshCheck" == "On" ] ; then
        echo
    elif [ "$sshCheck" == "Off" ] ; then
        userID="$(/usr/bin/dscl localhost -read /Local/Default/Users/$targetUsername | grep GeneratedUID | awk '{print $2}')"
        if [ "$userID" != "" ];then
            echo "Granting SSH Access for $targetUsername with GUID $userID"
            /usr/bin/dscl localhost -create /Local/Default/Groups/com.apple.access_ssh
            /usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh GroupMembership "$targetUsername"
            /usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh GroupMembers "$userID"
            /usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh RealName 'Remote Login Group'
            /usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh PrimaryGroupID 104
            systemsetup setremotelogin on
            echo
        else
            echo "No record was found for $targetUsername"
        fi
    else
        echo "Something went wrong"
    fi
    echo
}

# enable ARD ------------------------------------------------------------------
function enableARD {
    echo "Enabling ARD"
    echo
    privs="-DeleteFiles -ControlObserve -TextMessages -OpenQuitApps -GenerateReports -RestartShutDown -SendFiles -ChangeSettings"
    /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -specifiedUsers
    /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -access -on -privs $privs -users $targetUsername
    echo
}

# set Hostname ----------------------------------------------------------------
function setHostname {
    printf "Use serial number for hostname? (y/n) > "
    read A
    if [ "$A" == "y" ] ; then
        serial="$(/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Serial\ Number\ \(system\)/ {print $NF}')"
        scutil --set ComputerName $serial
        scutil --set HostName $serial
        scutil --set LocalHostName $serial
        echo
    elif [ "$A" == "n" ] ; then
        printf "Enter the new host name here -> "
        read B
        scutil --set ComputerName $B
        scutil --set HostName $B
        scutil --set LocalHostName $B
        echo
    else
        echo
    fi
    echo
}

# set Timezone ----------------------------------------------------------------
function setTime {
    timeZone="America/New_York"
    echo "Setting Timezone to $timeZone"
    /usr/sbin/systemsetup -settimezone "$timeZone"
    /usr/bin/killall SystemUIServer
    echo
}

# install Chrome --------------------------------------------------------------
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
    echo
}

function askInstallChrome {
    printf "Install Google Chrome (y/n) -> "
    read B
    if [ "$B" == "y" ] ; then
        installChrome
    elif [ "$B" == "y" ] ; then
        echo
    else
        echo "Invalid option."
        askInstallChrome
    fi
    echo
}

# remove unnecessary apps -----------------------------------------------------
function rmApps {
    cd /Applications
    echo "Removing Pages, Numbers, and Keynote"
    rm -rf Pages.app
    rm -rf Keynote.app
    rm -rf Numbers.app
    echo "Removing GarageBand and iMovie"
    rm -rf iMovie.app
    rm -rf GarageBand.app
    echo "Removing Supporting Files"
    rm -rf /Library/Application\ Support/GarageBand
    rm -rf /Library/Application\ Support/Logic
    rm -rf /Library/Audio/Apple\ Loops
    rm -rf /Library/Audio/Apple\ Loops\ Index
    rm -rf /Library/Application\ Support/iLifeMediaBrowser
    echo "Process Complete"
    echo
}

# systemsetup settings --------------------------------------------------------
function systemSetup {
    echo
    echo "Setting restart on power failure --> on"
    systemsetup -setrestartpowerfailure on
    echo "Setting wake on network access --> on"
    systemsetup -setwakeonnetworkaccess on
    echo "Setting restart on freeze --> on"
    systemsetup -setrestartfreeze on
    # sleep settings
    echo
    echo "Setting hard disk sleep --> never"
    systemsetup -setharddisksleep never
    echo "Setting display sleep --> 2 minutes"
    systemsetup -setdisplaysleep 2
    echo "Setting computer sleep --> never"
    systemsetup -setcomputersleep never
    # change login windows to username, password
    defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool True
}

# softwareupdate preferences --------------------------------------------------
function softwareUpdatePrefs {
    echo "Setting Software Update Settings..."
    # -- com.apple.commerce plist --
    # make sure checking for software updates is on
    echo "Ensuring checking for software updates is ON"
    softwareupdate --schedule on
    # disable automatic app updates
    echo "Disabling automatic app updates"
    defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool FALSE
    # disable automatic macOS updates
    echo "Disabling automatic macOS updates"
    defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool FALSE
    # -- com.apple.SoftwareUpdate plist -- 
    # disable automatic download of updates
    echo "Disabling automatic download of updates"
    defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool FALSE
    # part 1 of disabling install system data files
    echo "Part 1 Disabling install system data files"
    defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool FALSE
    # part 2 of disabling install system data files
    echo "Part 2 Disabling install system data files"
    defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool FALSE
}

# Finder preferences ----------------------------------------------------------
function writeFinderPrefs {
    echo "Setting Finder.app preferences..."
    echo "Changing default settings --> Show Hard Drives on the Desktop"
    defaults write /Users/$targetUsername/Library/Preferences/com.apple.finder.plist ShowHardDrivesOnDesktop -bool true
    echo "Changing default settings --> Show Mounted Servers On the Desktop"
    defaults write /Users/$targetUsername/Library/Preferences/com.apple.finder.plist ShowMountedServersOnDesktop -bool true
    echo "Changing default settings --> Show External Hard Drives On the Desktop"
    defaults write /Users/$targetUsername/Library/Preferences/com.apple.finder.plist ShowExternalHardDrivesOnDesktop -bool true
    chown $targetUsername /Users/$targetUsername/Library/Preferences/com.apple.finder.plist
    echo
}

# make Scripts directory ------------------------------------------------------
function mkScriptsDir {
    # prompt to install Xcode Developer tools if not installed to install git
    git
    printf "Create Scripts directory at / and clone macserver repo to /Scripts/macserver? (y/n) -> "
    read C
    if [ "$C" == "y" ] ; then
        echo "Creating /Scripts"
        mkdir /Scripts
        echo "Cloning macserver repo into /Scripts"
        cd /Scripts
        git clone https://github.com/rhymeswithfleece/macserver.git
    if [ "$C" == "n" ] ; then
        echo "Continuing to software updates"
    else
        echo "Invalid option."
        mkScriptsDir
}

# run system updates ----------------------------------------------------------
function softwareUpdates {
    echo "Running system updates"
    softwareupdate -i -a
}

# restart device --------------------------------------------------------------
function shutDownR {    
    echo "Restarting the device in 10 seconds"
    sleep 10
    shutdown -r now
}

# Script Contents -------------------------------------------------------------
checkPrivs
sshCheckEnable
enableARD
setHostname
setTime
mkScriptsDir
askInstallChrome
rmApps
systemSetup
softwareUpdatePrefs
writeFinderPrefs
softwareUpdates
shutDownR
# -----------------------------------------------------------------------------
