#!/bin/bash
# run the High Sierra installer
# make sure installer is downloaded on devices first and then have users run this script
# could make a smart group for the Self Service policy to only allow the script to kick off if the installer is there

# change to NO if you do not wish to convert to APFS
cvrtAPFS="YES"

if [ -e /Applications/Install\ macOS\ High\ Sierra.app ] ; then
    echo "Beginning High Sierra installation, this will take approximately an hour"
    startosinstall --applicationPath /Applications/Install\ macOS\ High\ Sierra.app \
        --agreetolicense \
        --nointeraction \
        --converttoapfs "$cvrtAPFS"
else
    exit
fi
