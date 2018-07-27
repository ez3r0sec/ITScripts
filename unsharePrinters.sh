#!/bin/bash
# -----------------------------------------------------------------------------
# unsharePrinters.sh
# turn off printer sharing
# a bit of a hack but works in a pinch
# Last Edited: 6/15/18
# -----------------------------------------------------------------------------
# Based on command below
# lpadmin -p <printer_name> -o printer-is-shared=false where <printer_name>
# ------------------------------------------------------------------------------
#variables
printerList2="$(cat /Library/Preferences/org.cups.printers.plist | grep 'string')"

echo "$printerList2" > /tmp/greppedPrinters.txt
cat /tmp/greppedPrinters.txt | while read line
    do
        lenLine="${#line}"
        cutString="$((($lenLine - 17)))"
        realPrinters="${line:8:$cutString}"
        echo "$realPrinters"
        lpadmin -p "$realPrinters" -o printer-is-shared=false
    done
exit
# -----------------------------------------------------------------------------
