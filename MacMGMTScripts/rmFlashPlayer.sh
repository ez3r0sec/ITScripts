#!/bin/bash
# -----------------------------------------------------------------------------
# rmFlashPlayer.sh
# remove flash player
# Last Edited: 6/19/18 Julian Thies
# -----------------------------------------------------------------------------
if [ "$(whoami)" != "root" ] ; then
    echo "Script must be run as root or with sudo privileges"
    exit
fi

if [ -e "/Library/Internet Plug-Ins/Flash Player.plugin" ] ; then
    echo "Removing Adobe Flash Player"
    echo "Removing components from /Users/$currentUser/Library/"
    rm -rf /Users/*/Library/Preferences/Macromedia
    rm -rf /Users/*/Library/Caches/Adobe
    rm -rf /Users/*/Library/Caches/com.adobe.flashplayer.installmanager
    echo "Removing components from /Library/"
    rm -rf "/Library/Application Support/Adobe/Flash Player Install Manager"
    rm -rf "/Library/Application Support/Macromedia"
    rm -f /Library/Application/LaunchDaemons/com.adobe.fpsaud.plist
    rm -f /Library/Application/Logs/FlashPLayerInstallManager.log
    rm -f "/Library/PrefencePanes/Flash Player.prefPane"
    rm -rf "/Library/Internet Plug-Ins/Flash Player.plugin"
    echo "Adobe Flash Player Removed"
else
  echo "Flash is not installed on this system"
fi
exit
# -----------------------------------------------------------------------------
