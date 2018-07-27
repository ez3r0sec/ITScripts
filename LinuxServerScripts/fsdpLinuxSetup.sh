#!/bin/bash
# -----------------------------------------------------------------------------
# fsdpLinuxSetup.sh
# Install File Share Distribution Point on Ubuntu 16.04.2 LTS using samba
# Last Edited: 6/18/17
# -----------------------------------------------------------------------------
# https://www.jamf.com/jamf-nation/articles/215/setting-up-a-file-share-distribution-point-on-#linux-using-samba
# -----------------------------------------------------------------------------
# functions
function check_user {
	if [ "$(whoami)" != "root" ] ; then
		echo "Script must be run as root or using sudo privileges"
		exit
	fi
}
function runUpdates {
    echo
    echo "Updating the host machine..."
    echo
    apt-get update
    apt-get upgrade -y
    shutdown -r now
}

function userConfig {
    echo
    echo "Adding users..."
    echo
    userType="read/write"
    printf "Type a username for the $userType user. User folder will be added in the default path
-> "
    read B
    echo "$B" > /tmp/rwUser.txt
    useradd -d /home/$B $B -s /bin/false -N
    echo "Enter a password for the user"
    smbpasswd -a $B
    
    userType="read only"
    printf "Type a username for the $userType user. User folder will be added in the default path
-> "
    read C
    echo "$C" > /tmp/readUser.txt
    useradd -d /home/$C $C -s /bin/false -N
    echo "Enter a password for the user"
    smbpasswd -a $C
}

function makeShare {
    echo
    echo "Making smb share..."
    echo
    printf "(1) Default share name and path or (2) define name and path? -> "
    read D
    if [ "$D" == "1" ] ; then
	mkdir -p /srv/samba/CasperShare
	chown casperadmin /srv/samba/CasperShare/
	chmod 755 /srv/samba/CasperShare/
	echo "CasperShare" > /tmp/shareName.txt
	echo "/srv/samba/CasperShare" > /tmp/sharePath.txt
    elif [ "$D" == "2" ] ; then
	printf "Enter a name for the new share -> "
	read E
	echo "$E" > /tmp/shareName.txt
	newShareName=$E
	printf "Enter the path to the new share -> "
	read F
	echo "$F" > /tmp/sharePath.txt
	newSharePath=$F
	rwUser="$(cat /tmp/rwUser.txt)"
	mkdir -p "$F/$E"
	chown  $rwUser "$F/$E/"
	chmod 755 "$F/$E/"
    else
	makeShare
    fi
}

# **************** DO NOT EDIT THIS SECTION ****************
function writeSMBConfig {
# collect variables
    shareName="$(cat /tmp/shareName.txt)"
    sharePath="$(cat /tmp/sharePath.txt)"
    readUser="$(cat /tmp/readUser.txt)"
    writeUser="$(cat /tmp/rwUser.txt)"
    echo
    echo "Building the smb.conf file in /tmp..."
    echo
    echo "[global]" > /tmp/smb.conf
    echo "    workgroup = WORKGROUP" >> /tmp/smb.conf
    echo "        server string = %h server (Samba, Ubuntu)" >> /tmp/smb.conf
    echo "    dns proxy = no" >> /tmp/smb.conf
    echo "    log file = /var/log/samba/log.%m" >> /tmp/smb.conf
    echo "    max log size = 1000" >> /tmp/smb.conf
    echo "    syslog = 0" >> /tmp/smb.conf
    echo "    panic action = /usr/share/samba/panic-action %d" >> /tmp/smb.conf
    echo "    server role = standalone server" >> /tmp/smb.conf
    echo "    obey pam restrictions = yes" >> /tmp/smb.conf
    echo "    unix password sync = yes" >> /tmp/smb.conf
    echo "    passwd program = /usr/bin/passwd %u" >> /tmp/smb.conf
    echo "    passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* ." >> /tmp/smb.conf
    echo "    pam password change = yes" >> /tmp/smb.conf
    echo "    map to guest = bad user" >> /tmp/smb.conf
    # non-default options
    echo "# Share Definitions" >> /tmp/smb.conf
    echo "# Generated via script - Julian Thies" >> /tmp/smb.conf
    echo "[$shareName]" >> /tmp/smb.conf
    echo "comment = $shareName" >> /tmp/smb.conf
    echo "path = $sharePath" >> /tmp/smb.conf
    printf "Make share browseable? Type yes or no -> "
    read G
    echo "browseable = $G" >> /tmp/smb.conf
    printf "Guest ok? Type yes or no -> "
    read H
    echo "guest ok = $H" >> /tmp/smb.conf
    printf "Read Only? Type yes or no -> "
    read I
    echo "read only = $I" >> /tmp/smb.conf
    echo "create mask = 0755" >> /tmp/smb.conf
    echo "read list = $readUser" >> /tmp/smb.conf
    echo "write list = $writeUser" >> /tmp/smb.conf
    echo "valid users = $writeUser, $readUser" >> /tmp/smb.conf
}
# **************** DO NOT EDIT THIS SECTION ****************

function checkConf {
    echo
    echo "Checking configuration file..."
    echo
    cat /tmp/smb.conf
    echo
    printf "Is the configuration file correct? (y/n) -> "
    read J
    if [ "$J" == "y" ] ; then
	cp /tmp/smb.conf /etc/samba/smb.conf
	service smbd restart
    elif [ "$J" == "n" ] ; then
	writeSMBConfig
	checkConf
    else
	checkConf
    fi
}

function upgradesFiles {
    echo
    printf "Set up unattended upgrades? (y/n) -> "
    read K
    if [ "$K" == "y" ] ; then
    	echo "Copying configuration files for unattended upgrades..."
	cp ~/vboxLinux/50unattended-upgrades /etc/apt/apt.conf.d
	cp ~/vboxLinux/10periodic /etc/apt/apt.conf.d
	"Shutting Down"
	sleep 10
	shutdown -r now
    elif [ "$K" == "n" ] ; then
    	echo "Restarting"
	sleep 10
	shutdown -r now
    else
    	upgradesFiles
    fi	
}

# make Scripts directory -------------------------------------------------------
function mkScriptsDir {
    if [ -d "/Scripts" ] ; then
        rm -rf /Scripts
	mkdir /Scripts
	cd /Scripts
	echo "Cloning vboxLinux repo into /Scripts"
	git clone https://github.com/ez3r0sec/LinuxServerScripts.git
    else
	echo
	echo "Creating /Scripts"
	mkdir /Scripts
	echo
	echo "Cloning vboxLinux repo into /Scripts"
	cd /Scripts
	git clone https://github.com/ez3r0sec/LinuxServerScripts.git
    fi
}

function taskSelect {
    echo
    printf "Would you like to skip to a certain task (type "n" to proceeed with full setup)?
1 Install samba
2 Configure users
3 Make the share directory
4 Configure samba
5 Configure unattended upgrades
Type a number or n to begin standard setup
-> "
    read L
    if [ "$L" == "1" ] ; then
    	apt-get install samba -y
    elif [ "$L" == "2" ] ; then
    	userConfig
    elif [ "$L" == "3" ] ; then
    	makeShare
    elif [ "$L" == "4" ] ; then
    	writeSMBConfig
	checkConf
    elif [ "$L" == "5" ] ; then
    	upgradesFiles
    elif [ "$L" == "n" ] ; then
    	echo "Installing samba..."
	apt-get install samba
        userConfig
        makeShare
	writeSMBConfig
	checkConf
	upgradesFiles
    else
    	taskSelect
    fi
}

function fsdpLinux {
    printf "Is the host up to date? (y/n) -> "
    read A
    if [ "$A" == "n" ] ; then
        mkScriptsDir
	runUpdates
    elif [ "$A" == "y" ] ;  then
	taskSelect
    else
	fsdpLinux
    fi
}

# Script Contents -------------------------------------------------------------
check_user
fsdpLinux     # sorting master function
exit
# -----------------------------------------------------------------------------
