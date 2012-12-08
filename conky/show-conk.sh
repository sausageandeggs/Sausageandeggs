#!/bin/sh

file1="/home/simon/.todo/notes"
file2="/home/simon/.todo/notes2"

	#cat /home/simon/.todo/notes | grep -v ^$ > /home/simon/.todo/.notes2
	cat ${file1} | grep -v ^$ > ${file2}

while read line; do
	echo "\${goto 59} $line"
done < ${file2}

