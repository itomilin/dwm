#!/usr/bin/env bash

# reqs: xosd-bin
bat=`cat /sys/class/power_supply/BAT0/capacity`
date=`date +%r%n%D`
echo -e "$bat\n$date" | osd_cat -A center -p middle -f -*-*-bold-*-*-*-100-120-*-*-*-*-*-* -cgreen -d 2

