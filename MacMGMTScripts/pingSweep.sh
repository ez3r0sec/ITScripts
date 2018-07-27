#!/bin/bash
# ------------------------------------------------------------------------------
# pingSweep.sh
# sweep private address ranges and record the hosts that respond to ping requests
# param $1 is the first octet of the private address range you wish to scan
# ------------------------------------------------------------------------------
# variables
userName="$(id -un)"
destFile="/Users/$userName/Desktop/networkHosts.txt"
# ------------------------------------------------------------------------------
# functions
function sweep_10 {
	octet1=10
	octet2=0
	octet3=0
	octet4=0
	while [[ "$octet2" -le 255 ]]
	do
		while [[ "$octet3" -le 255 ]] 
		do
			while [[ "$octet4" -le 255 ]]
			do
				hostIP="$octet1.$octet2.$octet3.$octet4"
				echo "Pinging $hostIP"
				pingHost="$(ping -c 2 $hostIP | grep 'Request timeout for icmp_seq 0')"
				if [ "$pingHost" == "" ] ; then
					echo "$hostIP" >> "$destFile"
				fi
				octet4=$((octet4 + 1))
			done
			octet3=$((octet3 + 1))
			octet4=0
		done
		octet2=$((octet2 + 1))
		octet3=0
	done
}

function sweep_172 {
	octet1=172
	octet2=16
	octet3=0
	octet4=0
	while [[ "$octet2" -le 31 ]]
	do
		while [[ "$octet3" -le 255 ]] 
		do
			while [[ "$octet4" -le 255 ]]
			do
				hostIP="$octet1.$octet2.$octet3.$octet4"
				echo "Pinging $hostIP"
				pingHost="$(ping -c 2 $hostIP | grep 'Request timeout for icmp_seq 0')"
				if [ "$pingHost" == "" ] ; then
					echo "$hostIP" >> "$destFile"
				fi
				octet4=$((octet4 + 1))
			done
			octet3=$((octet3 + 1))
			octet4=0
		done
		octet2=$((octet2 + 1))
		octet3=0
	done
}

function sweep_192 {
	octet1=192
	octet2=168
	octet3=0
	octet4=0
	while [[ "$octet3" -le 255 ]] 
	do
		while [[ "$octet4" -le 255 ]]
		do
			hostIP="$octet1.$octet2.$octet3.$octet4"
			echo "Pinging $hostIP"
			pingHost="$(ping -c 2 $hostIP | grep 'Request timeout for icmp_seq 0')"
			if [ "$pingHost" == "" ] ; then
				echo "$hostIP" >> "$destFile"
			fi
			octet4=$((octet4 + 1))
		done
		octet3=$((octet3 + 1))
		octet4=0
	done
}

# ------------------------------------------------------------------------------
if [ "$1" == "" ] ; then
	echo "Pass in the first octet of the private address range you wish to scan param 1 (ex. 172)"
	exit
elif [ "$1" == "10" ] ; then
	sweep_10
elif [ "$1" == "172" ] ; then
	sweep_172
elif [ "$1" == "192" ] ; then
	sweep_192
fi
echo "---- Testing Complete ----"
exit
# ------------------------------------------------------------------------------
