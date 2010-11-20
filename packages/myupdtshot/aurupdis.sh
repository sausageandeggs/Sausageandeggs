#!/bin/bash
export DISPLAY=:0
updtlist=/tmp/aurupdis.list
bauerbill -Qu --aur | grep AUR/ > $updtlist

conky -c /home/sas/.conkycolors/aurupdis/aurupdis.conf

sleep 300
pkill -f 'conky -c /home/sas/.conkycolors/aurupdis/aurupdis.conf'
rm $updtlist
