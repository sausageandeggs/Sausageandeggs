#!/bin/bash

updtlist=/tmp/aurupdis.list
#bauerbill -Qu --aur > $updtlist

cat $updtlist | grep -v ^$ | grep AUR | cut -d/ -f2 | awk '{print "\${goto 50}\${color2} " $1 " \${color1}\$alignr "$2 "\${color0} ==> \${color1}" $4 } ' 2>/dev/null

