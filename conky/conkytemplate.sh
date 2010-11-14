#!/bin/bash
# conkytemplate.sh
# by Crinos512
# Usage:
#  ${execpi 3600 ~/.conkycolors/conkyparts/conkytemplate.sh}
#
UseImage="1"
#Image="/home/sas/pictures/24.jpg"
#ImageSize="380x900"
#BGColor="Black"
#Columns=12
#Rows=17
#Layers=5

### FIX FOR KDE4 TRANSPARENCY
#feh --bg-scale "`grep 'wallpaper=' ~/.kde/share/config/plasma-desktop-appletsrc | head -n1 | tail --bytes=+11`"

### DO NOT EDIT BELOW THIS LINE
if [ "$UseImage" -eq "1" ]; then
  #echo "\${image $Image -p 0,0 -s $ImageSize}"
    g=1
    while [ $g -lt $Layers ]; do
      #echo "\${voffset -10}\${image $Image -p 0,0 -s $ImageSize}"
      let g=g+1
    done
else 
  for ((x=1; x < =  $Rows; x++))
  do
    case "$x" in
      1)
        Prefix="\${font conkybackgroundfi:size=13.5}\${color $BGColor}"
        BeginPart="\${goto 0}E"
        MidPart=""
        EndPart="F"
        i=$((Columns-2))
        ;;
      $Rows)
        Prefix=""
        BeginPart="\${goto 0}G"
        MidPart=""
        EndPart="C"
        i=$((Columns-2))
        ;;
      *)
        Prefix=""
        BeginPart="\${goto 0}"
        MidPart=""
        EndPart=""
        i=$Columns
        ;;
    esac
    while [ $i -gt 0 ]; do
      MidPart="${MidPart}D"
      let i=i-1
    done
    Part="${BeginPart}${MidPart}${EndPart}"
    g=0
    Line=""
    while [ $g -lt $Layers ]; do
      Line="${Line}${Part}"
      let g=g+1
    done
    echo "\${voffset -2}$Prefix$Line"
  done
  echo "\$font\$color\${voffset -$( echo "scale=9; $Rows*32" | bc )}"
fi
exit 0

