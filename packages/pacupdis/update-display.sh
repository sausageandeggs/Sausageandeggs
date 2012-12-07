#!/bin/bash

### GPLv3
### pacupdis Ver 0.95 ###
###### Config bit ######################################################################### {{{
left_font="\${goto 59}\${font liberation:bold:size=8}"  ## Font for Pkg name and version ##
right_font=""                                           ## Font for Pkg size 		 	 ##
right_color="\${color1}"                                ## Colour for Pkg size			 ##
core_color="\${color DF938F}"                           ## Colour for core pkgs 		 ##
extra_color="\${color0}"                                ## Colour for extra pkgs 	 	 ##
community_color="\${color CF9ECC}"                      ## Colour for community pkgs  	 ##
multilib_color="\${color 8FDF99}"                       ## Colour for multilib pkgs      ##
kernel26_ck_color="\${color C55154}"                    ## Colour for kerne26_ckpkgs     ##
xyne_color="\${color D3D181}"                           ## Colour for xyne-any pkgs   	 ##
seperator="\${color darkslategray}\${hr 2}"             ## Between updates and summary   ##
sumline="\${goto 59}\${color2}\${font liberation:bold:size=8}" ## Totals etc 			 ##
########################################################################################### }}}

list_updates() { #{{{
    declare -a all=() colour=() size=() totsize=()
    local let a=0 b=0 totalmb=0
    for j in ${updts[*]};do
        declare -a all[a]=$(expac -H M '%n-%v %r %m' -S $j)
        declare -a newver[a]="$(echo ${all[a]} | awk '{print $1}')"
        declare -a repo[a]="$(echo ${all[a]} | awk '{print $2}')"
        declare -a size[a]="$(echo ${all[a]} | awk '{print $3}')"
        declare -a totsize[a]=${size[a]}
        totalmb=$(echo ${size[a]} | awk '{print $1 + '$totalmb'}')
        (( a++ ))
    done

    for k in ${updts[*]};do
        case ${repo[b]} in
        core)
        colour[b]="$core_color" ;;
        extra)
        colour[b]="$extra_color" ;;
        community)
        colour[b]="$community_color" ;;
        multilib)
        colour[b]="$multilib_color" ;;
        xyne-any)
        colour[b]=$xyne_color ;;
        kernel26-ck)
        colour[b]=$kernel26_ck_color ;;
        esac
        printf "%b %.2f %b\n" "${left_font}${colour[b]}${newver[b]}${right_color}${right_font}\${alignr}" "${size[b]}" "Mb"
        (( b++ ))
    done
    echo "\${goto 59}${seperator}"
    if [[ ${#updts[*]} == "1" ]]; then
       printf "%b %.2f %b\n" "${sumline}Total: ${#updts[*]} update available\${alignr}" "${totalmb}" "Mb"
   else
       printf "%b %.2f %b\n" "${sumline}Total: ${#updts[*]} updates available\${alignr}" "${totalmb}" "Mb"
   fi
} #}}}

declare -a updts=($(sudo pacman -Qqu))
declare -a ignpkgs=($(sed -n "/IgnorePkg/s/^\s*IgnorePkg\s*=\([^#]*\).*$/\1/p" /etc/pacman.conf))

for i in ${ignpkgs[*]};do
    updts=(${updts[*]/$i/})
done

if [[ ${#updts[*]} == "0" ]]; then
    echo "\${voffset 10}\${alignc}\${font Arial:bold:size=10}\${color1}You are up to date"
else
    list_updates
fi

