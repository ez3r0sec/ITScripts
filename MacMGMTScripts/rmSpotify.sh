#!/bin/bash
# rmSpotify.sh
# remove spotify
# Last Edited: 10/19/18

### FUNCTIONS
function rmPrivateDirs {
	rm -r /private/var/folders/*/*/*/com.spotify.client
	rm -r /private/var/folders/*/*/*/com.spotify.installer
	rm -r /private/var/db/BootCaches/*/app.com.spotify.client.playlist
}

function rmUserDirs {
	rm -r /Users/*/Library/*/com.spotify.client.savedState
	rm -r /Users/*/Library/Preferences/com.spotify.client.plist
	rm -r /Users/*/Library/Preferences/com.spotify.client.helper.plist
	rm -r /Users/*/Library/Caches/com.spotify.installer
	rm -r /Users/*/Library/Caches/com.spotify.client
	rm -r /Users/*/Library/*/Spotify
	rm -r /Users/*/Library/*/CrashReporter/Spotify*.plist
}

function rmApp {
	# common locations
	app_loc="/Applications/Spotify.app"
	user_loc="/Users/$(id -un)/Applications/Spotify.app"
	
	if [ -e "$app_loc" ] ; then
		rm -r "$app_loc"
		echo "Process complete"
		exit
	elif [ -e "$user_loc" ] ; then
		rm -r "$user_loc"
		echo "Process complete"
		exit
	else
		find / -name "Spotify.app" 2> /dev/null > /tmp/spot.txt
		spot_app="$(wc -l < /tmp/spot.txt)"
		if [ "$spot_app" -eq 1 ] ;  then
			cat /tmp/spot.txt | while read line
			do
				rm -r "$line"
			done
		else:
			printf "Spotify app not found, type in the file path to the application bundle
			-> "
			read A
			if [ -e "$A" ] ; then
				echo "Removing $A"
				sleep 3
				rm -r "$A"
			else
				echo "$A does not exist, exiting"
			fi
		fi
		# clean up
		if [ -e /tmp/spot.txt ] ; then
			rm /tmp/spot.txt
		fi
	fi
}

# main function
function checkUser {
	if [ "$(whoami)" != "root" ] ; then
		echo "This script must be run as root or with sudo privileges"
		exit
	else
		printf "Remove Spotify? (y/n) -> "
		read B
		if [ "$B" == "n" ] ; then
			exit
		elif [ "$B" == "y" ] ; then
			rmPrivateDirs
			rmUserDirs
			rmApp
		else
			echo "Invalid input"
			checkUser
		fi
	fi
}

### SCRIPT
checkUser
