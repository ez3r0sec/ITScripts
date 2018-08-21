#!/bin/bash
# ----------------------------------------------------------------------------
# flashVersionCheck
# Extension attribute for Jamf Pro
# Checks local Adobe Flash Player version against latest version per
# http://www.adobe.com/software/flash/about/
# Last Edited: 10/29/17 Julian Thies
# ----------------------------------------------------------------------------

# deprecated version still listed on web page
depVersion="27.0.0.170"
#####################

# check local version
flashVersion="$(defaults read /Library/Internet\ Plug-Ins/Flash\ Player.plugin/Contents/version.plist | awk '/CFBundleVersion/ {print $(3) }')"
lenString="${#flashVersion}"
cutString="$((($lenString - 3)))"
localVersion="${flashVersion:1:$cutString}"

# curl html file
htmlFile="$(curl -sL http://www.adobe.com/software/flash/about/)"
echo "$htmlFile" > /tmp/AdobeFlashVersion.html

# reads html file and pulls out lines that include $localVersion
grep -v "$depVersion" /tmp/AdobeFlashVersion.html | grep "$localVersion" /tmp/AdobeFlashVersion.html >> /tmp/htmlVersion.txt

# read htmlVersion and cuts the strings down, then compares them to $localVersion
cat /tmp/htmlVersion.txt | while read line
do
  lenString="${#line}"
  cutString="$((($lenString - 9)))"
  webVersion="${line:4:$cutString}"
  if [ "$webVersion" == "$localVersion" ] ; then
    echo "$webVersion" > /tmp/Latest.txt
  else
    vers="Old"
  fi
done

# checks if the file /tmp/Newest.txt exists
if [ -f "/tmp/Latest.txt" ] ; then
  echo "<result>Latest</result>"
  exit
else
  echo "<result>Old</result>"
  exit
fi
exit
# ----------------------------------------------------------------------------
