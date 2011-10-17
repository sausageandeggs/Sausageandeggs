#!/bin/sh
#file="/home/sas/.todo/notes"
#file2="/home/sas/.todo/notes2"

#if [[ -N $file ]];then
	cat /home/sas/.todo/notes | grep -v ^$ > /home/sas/.todo/notes2
#fi
#cat /home/sas/.todo/notes2

while read line; do
	echo "\${goto 59} $line"
done < /home/sas/.todo/notes2

