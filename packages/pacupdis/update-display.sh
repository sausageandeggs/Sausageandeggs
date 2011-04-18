#!/bin/bash

###### Config bit ##########################################################
Lfont="\${font liberation:bold:size=8}"  ## Font for Pkg name and version ##
Rfont="\${font}"					     ## Font for Pkg size 		 	  ##
Rcolor="\${color1}" 					 ## Colour for Pkg size			  ##
core_color="\${color DF938F}"		     ## Colour for core pkgs 		  ##
extra_color="\${color0}"			     ## Colour for extra pkgs 	 	  ##
community_color="\${color CF9ECC}"	     ## Colour for community pkgs  	  ##
multilib_color="\${color 8FDF99}"	     ## Colour for multilib pkgs      ##
xyne_color="\${color D3D181}"		     ## Colour for xyne-any pkgs   	  ##
############################################################################

### pacupdis Ver 1.0 ###
declare -a vers=($(pacman -Quq))
declare -a colour
a=0
b=0
c=0
for j in ${vers[*]};do
	declare -a newver[a]="$(expac '%n-%v' -S $j)"
	declare -a repo[a]="$(expac $'%r' -S $j)"
	declare -a size[a]="$(expac '%k' -S $j)"
	(( a++ ))
done

for k in ${vers[*]};do
	case ${repo[b]} in
		core)
  			colour[b]=$core_color ;;
		extra)
			colour[b]=$extra_color ;;
		community)
			colour[b]=$community_color ;;
		multilib)
			colour[b]=$multilib_color ;;
		xyne-any)
			colour[b]=$xyne_color ;;
	esac
	echo -e "\${goto 59}${Lfont}${colour[b]}${newver[b]}${Rcolor}${Rfont}\${alignr}${size[b]}"
	(( b++ ))
done
