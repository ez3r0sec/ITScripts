#!/bin/bash
# -----------------------------------------------------------------------------
# apkgPull.sh
# script to define consistent AutoPKG pulls and make manual pulls easier
# Last Edited: 5/8/17
# -----------------------------------------------------------------------------
# define user
USER1="$(id -un)"

# -----------------------------------------------------------------------------
# update git recipes
echo
echo "Updating autopkg recipes..."
echo
autopkg repo-add recipes
# -----------------------------------------------------------------------------
# Function to open or not open /tmp/apkg and Casper Admin.app at the conclusion of the script
function openAdmin {
    printf "Would you like to open Casper Admin? (y/n)

-> "
    read C
    if [ "$C" = "y" ] ; then
        open /Applications/Casper\ Suite/Casper\ Admin.app
	echo
	echo "Opening Casper Admin..."
	echo
	echo "* * * * * * * *"
	echo
    elif [ "$C" = "n" ] ; then
	echo
	echo "Exiting..."
	echo
	echo "* * * * * * * *"
	echo
	exit
    else
	echo
	echo "*Invalid selection*"
    RunAPKG2
    fi
}
#-------------------------
function sayRecipes {
    echo
    echo "* * * * * * * * *"
    echo
    echo "* apkgPull *"
    echo
    echo "1 Adobe Flash Player"
    echo "2 Adobe Reader DC"
    echo "3 Firefox"
    echo "4 GNU Image Manipulation Program"
    echo "5 Google Chrome"
    echo "6 Google Drive"
    echo "7 LibreOffice"
    echo "8 Oracle Java"
    echo "9 VLC Player""
}

# define functions for each recipe (the cache folder does not necessarily follow a formula)
function FlashAPKG {
    echo
    echo "Running recipe for Adobe Flash Player..."
    echo
    autopkg run -v AdobeFlashPlayer.pkg
    open -n /Users/$USER1/Library/AutoPkg/Cache/com.github.autopkg.pkg.FlashPlayerExtractPackage/
}
function ReaderAPKG {
    echo
    echo "Running recipe for Adobe Reader DC..."
    echo
    autopkg run -v AdobeReaderDC.pkg
    open -n /Users/$USER1/Library/AutoPkg/Cache/com.github.autopkg.pkg.AdobeReaderDC/
}
function FirefoxAPKG {
    echo
    echo "Running recipe for Firefox..."
    echo
    autopkg run -v Firefox.pkg
    open -n /Users/$USER1/Library/AutoPkg/Cache/com.github.autopkg.pkg.Firefox_EN/
}
function GIMPAPKG {
    echo
    echo "Running recipe for GNU Image Manipulation Program..."
    echo
    autopkg run -v Gimp.pkg
    open -n /Users/$USER1/Library/AutoPkg/Cache/io.github.hjuutilainen.pkg.GIMP/
}
function ChromeAPKG {
    echo
    echo "Running recipe for Google Chrome..."
    echo
    autopkg run -v GoogleChrome.pkg
    open -n /Users/$USER1/Library/AutoPkg/Cache/com.github.autopkg.pkg.googlechrome/
}
function DriveAPKG {
    echo
    echo "Running recipe for Google Drive Desktop Client..."
    echo
    autopkg run -v GoogleDrive.pkg
    open -n /Users/$USER1/Library/AutoPkg/Cache/com.github.autopkg.cgerke-recipes.pkg.GoogleDrive/
}
function LibreOfficeAPKG {
    echo "Running recipe for LibreOffice..."
    autopkg run -v LibreOffice.pkg
    open -n /Users/$USER1/Library/AutoPkg/Cache/io.github.hjuutilainen.pkg.LibreOffice/
}
function JavaAPKG {
    echo
    echo "Running recipe for Oracle Java 8..."
    echo
    autopkg run -v OracleJava8.pkg
    open -n /Users/$USER1/Library/AutoPkg/Cache/com.github.autopkg.pkg.OracleJava8/
}
function VLCAPKG {
    echo
    echo "Running recipe for VLC Player..."
    echo
    autopkg run -v VLC.pkg
    open -n /Users/$USER1/Library/AutoPkg/Cache/com.github.autopkg.pkg.VLC/
}
#--------------------------
# Base function (do not edit)
function RunAPKG2 {
    printf "
Would you like to run another recipe? (y/n)

-> "
    read B
    if [ "$B" = "y" ] ; then
	sayRecipes
	RunAPKG
    elif [ "$B" = "n" ] ; then
	echo
	echo "Exiting apkgPull..."
	echo
	echo "* * * * * * * *"
	echo
	openAdmin
    else
        echo
	echo "*Invalid selection*"
	RunAPKG2
    fi
}
#------------------------------------------
# edit when adding additional recipes
function RunAPKG {
    printf "
Type the number of the recipe you would like to run

-> "
    read A
    if [ "$A" = "1" ] ; then
	FlashAPKG
    elif [ "$A" = "2" ] ; then
	ReaderAPKG
    elif [ "$A" = "3" ] ; then
	FirefoxAPKG
    elif [ "$A" = "4" ] ; then
	GIMPAPKG
    elif [ "$A" = "5" ] ; then
	ChromeAPKG
    elif [ "$A" = "6" ] ; then
	DriveAPKG
    elif [ "$A" = "7" ] ; then
	LibreOfficeAPKG
    elif [ "$A" = "8" ] ; then
	JavaAPKG
    elif [ "$A" = "9" ] ; then
	VLCAPKG
    else
	echo
	echo "*Invalid input*"
    fi
    RunAPKG2
}

# -----------------------------------------------------------------------------
# run functions
sayRecipes
RunAPKG
exit
# -----------------------------------------------------------------------------
