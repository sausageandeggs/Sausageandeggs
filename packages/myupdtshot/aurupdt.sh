#!/bin/bash

updtlist=/tmp/aurupdis.list

if [[ $(wc -l < $updtlist) == 0 ]]; then
	echo "${goto 50}${font Arial:bold:size=10}${color 9BC58B}    You are up to date"
else
	cat $updtlist | grep -v ^$ | grep AUR | cut -d/ -f2 | awk '{print "\${goto 50}\${color2} " $1 " \${color1}\$alignr "$2 "\${color0} ==> \${color1}" $4 } ' 2>/dev/null
fi

