#!/bin/bash
# -----------------------------------------------------------------------------
# serverReport.sh
# report on aspects of a Mac Server
# Last Edited: 6/19/18
# -----------------------------------------------------------------------------
# hardcode service data location
serviceDataLoc="/Library/Server"

# set up directory on desktop of server to hold report
dirDate="$(date +%Y-%m-%d)"
dirName="$dirDate-report"
mkdir ~/Desktop/$dirName

# -----------------------------------------------------------------------------
# check for privileges
if [ "$(whoami)" != "root" ] ; then
    echo "Script must be run as root or with sudo privileges"
    exit
fi

# copy logs to directory
cp /var/log/system.log ~/Desktop/$dirName

# disks
disksList="$(diskutil list)"
echo "$disksList" > ~/Desktop/$dirName/disks.txt

# free disk space
cd /
diskFree="$(df -agHl)"
echo "
Local Disk space

$diskFree" >> ~/Desktop/$dirName/disks.txt

# netstat
statNetAll="$(netstat -i)"
echo "$statNetAll" > ~/Desktop/$dirName/netStat.txt

# sysReport document
# hostname
nameHost="$(hostname)"
echo "$nameHost" > ~/Desktop/$dirName/sysReport.txt
echo "" >> ~/Desktop/$dirName/sysReport.txt
echo "Hostname is $nameHost" >> ~/Desktop/$dirName/sysReport.txt

echo "" >> ~/Desktop/$dirName/sysReport.txt
# uptime
minSinceBoot="$(/usr/sbin/system_profiler SPSoftwareDataType | /usr/bin/awk '/Time/ {print $4}')"
echo "$minSinceBoot (days:hours:minutes) since last boot" >> ~/Desktop/$dirName/sysReport.txt

# OS version
osVers="$(/usr/sbin/system_profiler SPSoftwareDataType | /usr/bin/awk '/System\ Version/ {print $4}')"
echo "macOS version is $osVers" >> ~/Desktop/$dirName/sysReport.txt

# model Identifier
modelIdent="$(/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Model\ Identifier/ {print $3}')"
echo "Model is $modelIdent" >> ~/Desktop/$dirName/sysReport.txt

# memory installed
memInstalled="$(/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Memory/ {print $2}')"
echo "$memInstalled GB RAM installed" >> ~/Desktop/$dirName/sysReport.txt

echo "" >> ~/Desktop/$dirName/sysReport.txt
# ip Address
addressIPW="$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')"
echo "WIFI IP address is $addressIPW" >> ~/Desktop/$dirName/sysReport.txt

addressIPe1="$(ifconfig en1 | /usr/bin/awk '/inet/ {print $2}')"
echo "Ethernet en1 IP address is $addressIPe1" >> ~/Desktop/$dirName/sysReport.txt

addressIPe2="$(ifconfig en2 | /usr/bin/awk '/inet/ {print $2}')"
echo "Ethernet en2 IP address is $addressIPe1" >> ~/Desktop/$dirName/sysReport.txt

echo "" >> ~/Desktop/$dirName/sysReport.txt
# list 501-503 user
userName1="$(dscl . list /Users UniqueID | awk '$2 == 501 {print $1}')"     # Lists 501 user
echo "
Users" >> ~/Desktop/$dirName/sysReport.txt
echo "501 user is $userName1" >> ~/Desktop/$dirName/sysReport.txt

# cron jobs
cronJobs="$(crontab -l)"
echo "
Cron jobs

$cronJobs" >> ~/Desktop/$dirName/sysReport.txt

# list scripts
cd ~/
scriptListShell="$(find / -name *.sh)"
echo "
Shell scripts

$scriptListShell" >> ~/Desktop/$dirName/sysReport.txt

# list launch agents and daemons
echo "" >> ~/Desktop/$dirName/sysReport.txt
echo "Launch Agents and Daemons /Library" >> ~/Desktop/$dirName/sysReport.txt
cd /Library/LaunchAgents
echo "" >> ~/Desktop/$dirName/sysReport.txt
echo "LaunchAgents" >> ~/Desktop/$dirName/sysReport.txt
echo "" >> ~/Desktop/$dirName/sysReport.txt
ls >> ~/Desktop/$dirName/sysReport.txt
cd /Library/LaunchDaemons
echo "" >> ~/Desktop/$dirName/sysReport.txt
echo "LaunchDaemons" >> ~/Desktop/$dirName/sysReport.txt
echo "" >> ~/Desktop/$dirName/sysReport.txt
ls >> ~/Desktop/$dirName/sysReport.txt

# list system launch agents and daemons
echo "" >> ~/Desktop/$dirName/sysReport.txt
echo "Launch Agents and Daemons /System/Library" >> ~/Desktop/$dirName/sysReport.txt
cd /System/Library/LaunchAgents
echo "" >> ~/Desktop/$dirName/sysReport.txt
echo "LaunchAgents" >> ~/Desktop/$dirName/sysReport.txt
echo "" >> ~/Desktop/$dirName/sysReport.txt
ls >> ~/Desktop/$dirName/sysReport.txt
cd /System/Library/LaunchDaemons
echo "" >> ~/Desktop/$dirName/sysReport.txt
echo "LaunchDaemons" >> ~/Desktop/$dirName/sysReport.txt
echo "" >> ~/Desktop/$dirName/sysReport.txt
ls >> ~/Desktop/$dirName/sysReport.txt

# list launch agents and daemons
echo "" >> ~/Desktop/$dirName/sysReport.txt
echo "Launch Agents and Daemons ~/Library" >> ~/Desktop/$dirName/sysReport.txt
cd ~/Library/LaunchAgents
echo "" >> ~/Desktop/$dirName/sysReport.txt
echo "LaunchAgents" >> ~/Desktop/$dirName/sysReport.txt
echo "" >> ~/Desktop/$dirName/sysReport.txt
ls >> ~/Desktop/$dirName/sysReport.txt

# Desktop files
cd ~/Desktop
filesDesktop="$(ls -1RF)"
echo "
Desktop Files
------------
$filesDesktop
------------
" > ~/Desktop/$dirName/files.txt

# Documents files
cd ~/Documents
filesDocuments="$(ls -1RF)"
echo "
Documents Files
------------
$filesDocuments
------------
" >> ~/Desktop/$dirName/files.txt

# Downloads files
cd ~/Downloads
filesDownloads="$(ls -1RF)"
echo "
Downloads Files
------------
$filesDownloads
------------
" >> ~/Desktop/$dirName/files.txt
# available software updates

#availUpdates="$(softwareupdate -l)"
#echo "$availUpdates" >> ~/Desktop/$dirName/sysReport.txt
exit
# -----------------------------------------------------------------------------
