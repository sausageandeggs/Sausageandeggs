#!/bin/bash

# Checkup Ver 2.991

# {{{ Blurb
# 
# Copyright Simon Stoakley 2009,2010
#
# Script to check if theres a nvidia update when there is an kernel update before updating.
# If not various options will be offered. Packages can also be ignored easily.
#
# Checkup is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Checkup is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with checkup.  If not, see <http://www.gnu.org/licenses/>. }}}

# {{{ Not root check
if [[ $UID -eq 0 ]]; then           
    echo -e "${bldwht}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${bldwht}##${bldred} Don't run this as root${bldwht} ##"
    echo -e "${bldwht}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    return 1
fi # }}}

# Variables {{{ 
. /usr/lib/sas/text-colors
cachedir="/media/arch/package-cache/"
updtfile="/media/three/local_bkup/updatedpkgs.log"
pacfirm="$1"
pacflag="--noconfirm"
[[ $pacfirm == "-c" ]] && pacflag=""
updt_cmd="sudo pacman-color " #-Su $pacflag "
updt_msg=""
ignpkg=""
set ""
# }}}

rolbak() {  # {{{
    echo
    echo -e "${bldwht}===>${bldgrn} Creating updated package list for easy rollback\n${txtrst}"
    # add $pkgver-$arch-pkg,tar.*z and put everything on 1 line
    d=0
    for l in ${oldver[*]};do 
        listvers[d]=$(ls -l $cachedir"$l"* | cut -d/ -f2-)
        (( d++ ))
    done
    echo $(date +%d%m-%I) >> $updtfile
    echo ${listvers[*]} >> $updtfile
} # }}}

bkpkg() { # {{{
    echo
    echo -e "${bldwht}===>${bldgrn} Backing up local database"
    mv /media/three/local_bkup/{old.tar.lrz,done.tar.lrz} || return 1
    mv /media/three/local_bkup/{local-*,old.tar.lrz} || return 1
    lrztar -q -L5 -o /media/three/local_bkup/local-$(date +%d%m).tar.lrz /var/lib/pacman/local/ 1>/dev/null 2>&1 || return 1
    rm /media/three/local_bkup/done.tar.lrz
    echo
}
# }}}

build_nvid() {  # {{{
        cd /projects/builds/nvidia-beta-all || return 1    ## updates fully then calls makepkg
        bumppkgrel PKGBUILD PKGBUILD                     ## to build (+ install) nvidia pkg
        makepkg -ic
        cd -
}  # }}}

ask_both() {  # {{{
    echo -e "${bldwht}===>${bldylw} There is a kernel update Do you want to..." 
    echo
    echo -e "${bldwht}===>${bldylw} Do you want to:${bldwht} (a)${bldylw} Update everyting and rebuild Nvidia" 
    echo -e "\t\t    ${bldwht} (b)${bldylw} Update everyting without rebuilding Nvidia"
    echo -e "\t\t    ${bldwht} (c)${bldylw} Update everything but the kernel"
    echo -e "\t\t    ${bldwht} (d)${bldylw} Run a custom command."
    echo -e "\t\t    ${bldwht} (e)${bldylw} Do nothing and exit."
    echo -en "${bldwht}===>${bldylw} What'll it be...:${bldwht}"
    read -n 1 choice

    case $choice in
        [Aa])
        updt_msg="${bldwht}===>${bldgrn}Updating everyting and rebuilding Nvidia"
        rebuild=1  ;;
        [Bb])
        updt_msg="${bldwht}===>${bldgrn}Updating everyting but not rebuilding Nvidia" ;;
        [Cc])
        updt_msg="${bldwht}===>${bldgrn}Updating everyting but the kernel" ;;
        [Dd])
        echo -e "${bldwht}===>${bldgrn}Enter command :"
        read updt_cmd
        updt_msg="${bldwht}===>${bldgrn}Running ${updt_cmd}" ;;
        [Ee])
        return 1 ;;
    esac
}  # }}}

ask_kern() {  # }}}
    echo -e "${bldwht}===>${bldylw} There is only a kernel update ." 
    echo
    echo -e "${bldwht}===>${bldylw} Do you want to:${bldwht} (a)${bldylw} Update the kernel and rebuild Nvidia" 
    echo -e "\t\t    ${bldwht} (b)${bldylw} Update kernel but dont rebuild Nvidia"
    echo -e "\t\t    ${bldwht} (c)${bldylw} Run a custom command."
    echo -e "\t\t    ${bldwht} (d)${bldylw} Do nothing and exit."
    echo -en "${bldwht}===>${bldylw} What'll it be...:${bldwht}"
    read -n 1 choice
    case $choice in
        [Aa])
        updt_msg="${bldwht}===>${bldgrn}Updating the kernel and rebuilding Nvidia"
        rebuild=1  ;;
        [Bb])
        updt_msg="${bldwht}===>${bldgrn}Updating the kernel but not rebuilding Nvidia" ;;
        [Cc])
        echo -e "${bldwht}===>${bldgrn}Enter command :"
        read updt_cmd
        updt_msg="${bldwht}===>${bldgrn}Running ${updt_cmd}" ;;
        [Dd])
        return 1 ;;
    esac
}  # }}}


echo
echo -en "${bldwht}===>${bldgrn} Do you want to refresh the database? y/N "
read -n 1 ans
echo
[[ $ans == "y" ]] && sudo pacman-color -Syy

##See if there are any updates at all and list them##
declare -a updates=($(pacman -Qqu))
# Get rid of ignored packages
declare -a ignpkgs=($(sed -n "/IgnorePkg/s/^\s*IgnorePkg\s*=\([^#]*\).*$/\1/p" /etc/pacman.conf))

for h in ${ignpkgs[*]};do
    updates=(${updates[*]/$h/})
done

### TODO notify that updates have been ignored ###
if [[ ${#updates[*]} == "0" ]]; then
echo -e "${bldwht}===>${bldred} You are up to date."
return 1
fi

# Print updates (old --> new) {{{

numb=${#updates[*]}
echo
if [[ $numb == "1" ]]; then
    echo -e "${bldwht}===>${bldgrn} There is one package to update"
  else
    echo -e "${bldwht}===>${bldgrn} There are $numb packages to update"
fi
echo

let a=0 b=0 c=0 WW="$(( $(tput cols)/2 - 2 ))"

for i in ${updates[*]};do
    declare -a oldver[$a]="$(expac '%n-%v' -s "$i" | grep -m 1 "^$i")"
    (( a++ ))
done
for j in ${updates[*]};do
    declare -a newver[$b]="$(expac '%n-%v' -S "$j" | grep -m 1 "^$j")"
    (( b++ ))
done
for k in ${updates[*]};do
    printf "%${WW}b %b %b\n" "${bldwht}${oldver[$c]}" "${bldgrn}-->" "${bldwht}${newver[$c]}"
    (( c++ ))
done #}}}

### --noconfirm msg ####
if [[ "$pacfirm" != "-c" ]] ;then
    echo
    echo -e "${bldwht}===>${bldred} Pacman will be called with the '--noconfirm' flag, call checkup with the '-c' flag to prevent this${txtrst}"
fi

######## ask if want to ignore any pkgs ####
echo
echo -e "${bldwht}===>${bldgrn} Do you want to: (i) Ignore pkgs"
echo -e "${bldgrn}\t\t     (f) Force the update"
echo -e "${bldgrn}\t\t     (b) Both force & ignore"
echo -e "${bldgrn}\t\t     (r) Run a custom cmd" 
echo -e "${bldgrn}\t\t     (N) run Normally"
echo -e "${bldgrn}\t\t     (q) Quit ${bldwht}"
echo -en "                     :"
read -n 1 for_ign
echo
case $for_ign in
[bB])
    echo -en "${bldwht}===>${bldgrn} Enter the pkgs you want to ignore (comma separated): ${txtrst}"
    read ignpkg
    updt_cmd+="-Suf ${ignpkg} ${pacflag}"
    echo -e "" ;;
[fF])
    updt_cmd+="-Suf ${pacflag}"
    echo -e "" ;;
[iI])
    echo -en "${bldwht}===>${bldgrn} Enter the pkgs you want to ignore (comma separated): ${txtrst}"
    read ignpkg
    updt_cmd+="-Su ${ignpkg} ${pacflag}"
    echo -e "" ;;
[nN])
    updt_cmd+="-Su ${pacflag}"
    echo -e "" ;;
[qQ])
    echo -e "${bldwht}===>${bldred} Goodbye"
    return 1 ;;
[rR])
    echo -en "${bldwht}===>${bldgrn} Enter command (will be run verbatim): ${txtrst}"
    read updt_cmd
    echo -e " $(date +%d%m-%I)\n $updt_cmd" >> $updtfile 
    echo
    sudo $updt_cmd
    return 1 ;;
esac

######check what needs to be updated#####
for u in ${updates[*]};do
    if [[  ${u} == 'linux' ]];then
        chkker=1
     fi
done

if [[ ${chkker} == "1" ]]; then
    declare -a others=(${updates[*]/linux/})
    [[ ${#other[*]} != 0 ]] && chkother=1
fi


###################
    
if [[ ${chkker} == "1" ]] && [[ ${chkother} != 1 ]] ; then
    ask_kern
  elif  [[ ${chkother} == 1 ]];then
    ask_both
fi
echo
echo "${updt_msg}"
${updt_cmd}
[[ ${choice} == "1" ]] && build_nvid
rolbak
bkpkg
