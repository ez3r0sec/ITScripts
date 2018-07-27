#!/bin/bash
# delete all safari extensions
# Last Edited: 6/15/18 Julian Thies

outputFile="/tmp/safariextz-file.txt"

# search whole disk for Safari Extensions
find / -name "*.safariextz" >> "$outputFile"

# remove all found .safariextz files
cat "$outputFile" | while read line
do
	rm "$line"
done

# clean up
rm "$outputFile"
