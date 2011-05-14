#!/bin/bash
export DISPLAY=:0
updtlist=/tmp/aurupdis.list
cower --nossl -u --color=never > $updtlist

conky -c /etc/conky/aurupdis.conf

sleep 300
pkill -f 'conky -c /etc/conky/aurupdis.conf'
rm $updtlist
