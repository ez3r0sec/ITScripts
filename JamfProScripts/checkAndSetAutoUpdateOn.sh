#!/bin/bash
# -----------------------------------------------------------------------------
# autoUpdateCheck.sh
# Check to see if auto updates are enabled and if not, enable them
# Last Edited: 6/15/18
# -----------------------------------------------------------------------------
# run weekly in JSS
# 1 = True, 0 = False
# -----------------------------------------------------------------------------
# parameter that specifies scheduled checking for updates
autoCheckEnabled="$(defaults read /Library/Preferences/com.apple.SoftwareUpdate | awk '/AutomaticCheckEnabled = / {print $(3) }')"

if [ "$autoCheckEnabled" != "1;" ] ; then
    # make sure checking for software updates is on
    softwareupdate --schedule on
fi
# -----------------------------------
# parameter for automatic app updates
commerceAutoUpdate="$(defaults read /Library/Preferences/com.apple.commerce | awk '/AutoUpdate = / {print $(3) }')"

if [ "$commerceAutoUpdate" != "1;" ] ; then
    # enable automatic app updates
    defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE
fi
# -----------------------------------
# parameter for macOS updates
autoMacUpdate="$(defaults read /Library/Preferences/com.apple.commerce | awk '/AutoUpdateRestartRequired = / {print $(3) }')"

if [ "$autoMacUpdate" != "1;" ] ; then
    # enable automatic macOS updates
    defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool TRUE
fi
# -----------------------------------
# parameter for automatic download of available updates
autoMacDownload="$(defaults read /Library/Preferences/com.apple.SoftwareUpdate | awk '/AutomaticDownload = / {print $(3) }')"

if [ "$autoMacDownload" != "1;" ] ; then
    # enable automatic download of updates
    defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool TRUE
fi
# -----------------------------------
# first parameter as part of "install system files" option
sysDataFiles1="$(defaults read /Library/Preferences/com.apple.SoftwareUpdate | awk '/CriticalUpdateInstall = / {print $(3) }')"

if [ "$sysDataFiles1" != "1;" ] ; then
    # part 1 of enabling install system data files
    defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool TRUE
fi
# -----------------------------------
# second parameter as part of "install system files" option
sysDataFiles2="$(defaults read /Library/Preferences/com.apple.SoftwareUpdate | awk '/ConfigDataInstall = / {print $(3) }')"

if [ "$sysDataFiles2" != "1;" ] ; then
    # part 2 of enabling install system data files
    defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool TRUE
fi
exit
# -----------------------------------------------------------------------------
