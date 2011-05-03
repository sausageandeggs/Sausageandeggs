#!/bin/bash

### pacupdis Ver 0.86 ###
###### Config bit #####################################################################
Lfont="\${goto 59}\${font liberation:bold:size=8}"  ## Font for Pkg name and version ##
Rfont="\${font}"                                    ## Font for Pkg size 		 	 ##
Rcolor="\${color1}"                                 ## Colour for Pkg size			 ##
core_color="\${color DF938F}"                       ## Colour for core pkgs 		 ##
extra_color="\${color0}"                            ## Colour for extra pkgs 	 	 ##
community_color="\${color CF9ECC}"                  ## Colour for community pkgs  	 ##
multilib_color="\${color 8FDF99}"                   ## Colour for multilib pkgs      ##
xyne_color="\${color D3D181}"                       ## Colour for xyne-any pkgs   	 ##
seperator="\${color darkslategray}\${hr 2}"         ## Between updates and summary   ##
sumline="\${goto 59}\${color1}\${font liberation:size=8}" ## Totals etc 			 ##
#######################################################################################

declare -a updts=($(sudo pacman -Quq))

show_updates() {
declare -a colour
let a=0 b=0 totalmb=0
for j in ${updts[*]};do
  declare -a newver[a]="$(expac '%n-%v' -S $j)"


  declare -a repo[a]="$(expac $'%r' -S $j)"
  declare -a size[a]="$(expac '%k' -S $j | awk '{print $1 / 1024}')"
  declare -a totsize[a]="$(expac '%k' -S $j | awk '{print $1}')"
  totalmb=$(echo ${size[a]} | awk '{print $1 + '$totalmb'}')
  (( a++ ))
done



core gawk-3.1.8-2
community hawknl-1.68-2

expac '%r %n-%v' -Ss



for k in ${updts[*]};do
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
  printf "%b %.2f %b\n" "\${goto 59}${Lfont}${colour[b]}${newver[b]}${Rcolor}${Rfont}\${alignr}" "${size[b]}" "Mb"
  (( b++ ))
done
echo "\${goto 59}${seperator}"
printf "%b %.2f %b\n" "${sumline}Total: ${#updts[*]} updates available\${alignr}" "${totalmb}" "Mb"
}

if [[ ${#updts[*]} == "0" ]]; then
  echo "\${voffset 10}\${alignc}\${font Arial:bold:size=10}\${color1}You are up to date"
  #echo ${seperator}
else
 show_updates
fi

bsort() {
	SORTEDARRAY=("$@")
	local i j t
	for (( i=${#SORTEDARRAY[@]}-1; i>0; i-- )); do
		for (( j=1; j<=i; j++ )); do
			# Swap if needed
			compare "${SORTEDARRAY[j-1]}" "${SORTEDARRAY[j]}" 
			(( $? == 3 )) || continue
			t="${SORTEDARRAY[j]}" # Placeholder for swapping elements
			SORTEDARRAY[j]="${SORTEDARRAY[j-1]}"
			SORTEDARRAY[j-1]="$t"
		done
	done
}


