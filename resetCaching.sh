#!/bin/bash
# -----------------------------------------------------------------------------
# resetCaching.sh
# reset caching server cache when it gets close to full
# ONLY TESTED THROUGH macOS 10.12 Sierra
# Last Edited: 7/11/18
# -----------------------------------------------------------------------------
# variables
hostName="$(hostname)"
starDate="$(date)"     # date for stamping logs
adminUser="$(id -un)"            # admin user of the server
logFile="/Users/$adminUser/Library/Logs/resetCachingLog.txt"     # log file location

# cache size variables
cacheSize="$(/Applications/Server.app/Contents/ServerRoot/usr/sbin/serveradmin settings caching | awk '/caching:CacheLimit/ {print $(3) }')"
cacheFree="$(/Applications/Server.app/Contents/ServerRoot/usr/sbin/serveradmin fullstatus caching | awk '/caching:CacheFree/ {print $(3) }')"
minCache="1000000000"

# print the location of the caching data
cachePath="$(/Applications/Server.app/Contents/ServerRoot/usr/sbin/serveradmin settings caching | awk '/caching:DataPath/ {print $(3) }')"
# cut string down so that we can remove the entire Caching folder later on
lenString="${#cachePath}"
cutString="$((($lenString - 14)))"
cutCachePath="${cachePath:1:$cutString}"

# sentinel variable to kick off functions
rmCache=""
# Functions -------------------------------------------------------------------
function checkPrivs {
    if [ "$(whoami)" != "root" ] ; then
        echo "Script must be run as root or with sudo privileges"
        exit
    fi
}

# check space remaining
function checkCache {
    if [ "$cacheFree" -lt "$minCache" ] ; then
	echo "cache has less than 10 GB remaining" >> "$logFile"
        rmCache="yes"
    elif [ "$cacheFree" -gt "$minCache" ] ; then
	echo "Cache has greater than 10 GB remaining" >> "$logFile"
    else
	echo "Cache remaining could not be calculated" >> "$logFile"
    fi
}
# stop the caching service
function stopCachingService {
    echo >> "$logFile"
    echo "$starDate --> Stopping the caching service..." >> "$logFile"
    /Applications/Server.app/Contents/ServerRoot/usr/sbin/serveradmin stop caching >> "$logFile"
}
# remove Caching data
function rmCachingData {
    echo "Removing $cutCachePath/Caching" >> "$logFile"
    rm -rf "$cutCachePath/Caching" >> "$logFile"
    sleep 10
}
# start the caching service and recreates the Caching folder
function restartCachingService {
    echo "Restarting the caching service..." >> "$logFile"
    /Applications/Server.app/Contents/ServerRoot/usr/sbin/serveradmin start caching >> "$logFile"
}

# Script Contents -------------------------------------------------------------
checkPrivs
echo >> "$logFile"
echo "---- $starDate -- $hostName ----" >> "$logFile"
echo "Cache Size == $cacheSize" >> "$logFile"
echo "Cache Free == $cacheFree" >> "$logFile"
# begin calling functions
checkCache
if [ "$rmCache" == "yes" ] ; then
    stopCachingService
    rmCachingData
    restartCachingService
else
    echo "Exiting" >> "$logFile"
fi
echo "---- $starDate -- $hostName ----" >> "$logFile"
exit
# -----------------------------------------------------------------------------
