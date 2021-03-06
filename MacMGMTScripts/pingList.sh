#!/bin/bash
# pingList.sh
# ping a list of hosts by IP in order, read from a text file
# param $1 is the path to the file to read
# Last Edited: 8/21/18 Julian Thies

# file format
##############################
#~
#10.0.0.1
#10.0.0.2
#10.0.0.240
#10.0.0.5
#10.0.4.8
#~
##############################

if [ "$1" == "" ] ; then
	echo "Pass in the IP file path as param 1"
	exit
else
	echo "---- Commencing ping test ----"
fi

cat $1 | while read line
do
	pingHost="$(ping -c 2 $line | grep 'Request timeout for icmp_seq 0')"
	if [ "$pingHost" != "" ] ; then
		echo "*** $line --> UNREACHABLE ***"
	else
		echo "$line is up"
	fi
done
echo "---- Ping test complete ----"
exit
