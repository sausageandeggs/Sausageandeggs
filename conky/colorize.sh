#!/bin/bash
# colorize.sh
# by Crinos512
# Usage:
#  ${execpi 6 sensors | grep 'Core 0' | paste -s | cut -c15-18 | xargs ~/.conky/conkyparts/colorize.sh} ... $color
# or
#  ${execpi 6 sensors | grep 'Core 0' | paste -s |sed 's/°/\n/'| head -n1 | cut -c15- | xargs ~/.conky/conkyparts/colorize.sh} ... $color
#
# Note: Assign color7, color8, and color9 to COOL, WARM, and HOT respectively
#   your .conkyrc

COOL=40
WARM=55

if [[ $1 -lt $COOL ]]
   then echo "\${color7}"$1    # COOL
elif [[ $1 -gt $WARM ]]
   then echo "\${color9}"$1    # HOT
else echo "\${color8}"$1       # WARM
fi

exit 0

