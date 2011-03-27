#!/bin/bash

updtlist=/tmp/aurupdis.list

if [[ $(cat $updtlist | wc -l ) == 0 ]]; then
	echo "\${goto 50}\${font Arial:bold:size=10}\${color 9BC58B}    Source packages up to date"
else
	cat $updtlist | sed 's#::##g' | awk '{print "\${goto 50}\${color2} " $1 " \${color1}\$alignr "$2 "\${color0} ==> \${color1}" $4 } ' 2>/dev/null
fi

