#!/bin/bash

# Checkup Ver 3.0

# {{{ Blurb
# 
# Copyright Simon Stoakley 2009-2011
#
# Script that optionally rebuilds nvidia module when there is an kernel update.
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
nvidia_dir="/projects/builds/nvidia-beta-all"
pacfirm="$1"
pacflag="--noconfirm"
[[ $pacfirm == "-c" ]] && pacflag=""
updt_cmd="sudo pacman-color -S "
unset updt_msg ignpkg rebuild choice for_ign chkker chkother updates others ignpkgs
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
    echo -e "\n${bldwht}===>${bldgrn} Backing up local database"
    mv /media/three/local_bkup/{old.tar.lrz,done.tar.lrz} || return 1
    mv /media/three/local_bkup/{local-*,old.tar.lrz} || return 1
    lrztar -q -L5 -o /media/three/local_bkup/local-$(date +%d%m).tar.lrz /var/lib/pacman/local/ 1>/dev/null 2>&1 || return 1
    rm /media/three/local_bkup/done.tar.lrz
    echo
}
# }}}

build_nvid() {  # {{{
        echo -e "\n${bldwht}===>${bldblu} Rebuilding Nvidia kernel module${txtrst}\n"
        cd $nvidia_dir || return 1
        bumpkgrel PKGBUILD PKGBUILD
        makepkg -ic
        cd -
} # }}}

ask_both() {  # {{{
    echo
    local choice
    echo -e "${bldwht}===>${bldcyn} There is a kernel update Do you want to..." 
    echo
    echo -e "${bldwht}===>${bldcyn} Do you want to:${bldwht} (1)${bldcyn} Update everyting and rebuild Nvidia${txtwht} (default)" 
    echo -e "\t\t    ${bldwht} (2)${bldcyn} Update everyting without rebuilding Nvidia"
    echo -e "\t\t    ${bldwht} (3)${bldcyn} Update everything but the kernel"
    echo -e "\t\t    ${bldwht} (4)${bldcyn} Update just the kernel and rebuild Nvidia"
    echo -e "\t\t    ${bldwht} (5)${bldcyn} Update just the kernel without rebuilding Nvidia"
    echo -e "\t\t    ${bldwht} (6)${bldcyn} Run a custom cmd" 
    echo -e "\t\t    ${bldwht} (7)${bldcyn} Do nothing and exit."
    echo -en "${bldwht}===>${bldcyn} What'll it be...:${txtrst}"
    read -n 1 choice
    echo
    choice=${choice:-1}   ## default to option 1

    case $choice in
        1)
        updt_cmd+="-u ${pacflag} "
        updt_msg="${bldwht}===> ${bldgrn}Updating everyting and rebuilding Nvidia${txtrst}"
        rebuild=1  ;;
        2)
        updt_cmd+="-u ${pacflag} "
        updt_msg="${bldwht}===> ${bldgrn}Updating everyting but not rebuilding Nvidia${txtrst}" ;;
        3)
        updt_cmd+="-u --ignore linux,linux-headers ${pacflag} "
        updt_msg="${bldwht}===> ${bldgrn}Updating everyting but the kernel${txtrst}" ;;
        4)
        updt_cmd+="linux linux-headers ${pacflag} "
        updt_msg="${bldwht}===> ${bldgrn}Updating just the kernel and rebuilding Nvidia${txtrst}"
        rebuild=1  ;;
        5)
        updt_cmd+="linux linux-headers ${pacflag} "
        updt_msg="${bldwht}===> ${bldgrn}Updating just the kernel without rebuilding Nvidia${txtrst}" ;;
        6)
        echo
        echo -en "${bldwht}===> ${bldgrn}Enter command (will be run verbatim):${txtrst} "
        read updt_cmd
        updt_msg="${bldwht}===> ${bldgrn}Running ${updt_cmd}${txtrst}"
        echo -e " $(date +%d%m-%I)\n $updt_cmd" >> $updtfile 
        echo ;;
        7)
        unset updt_cmd
        return 1 ;;
    esac
}  # }}}

ask_kern() {  # {{{
    echo
    local choice
    echo -e "${bldwht}===>${bldpur} There is only a kernel update." 
    echo
    echo -e "${bldwht}===>${bldpur} Do you want to:${bldwht} (1)${bldpur} Update the kernel and rebuild Nvidia${txtwht} (default)" 
    echo -e "\t\t    ${bldwht} (2)${bldpur} Update kernel but dont rebuild Nvidia"
    echo -e "\t\t    ${bldwht} (3)${bldpur} Run a custom cmd" 
    echo -e "\t\t    ${bldwht} (4)${bldpur} Do nothing and exit."
    echo -en "${bldwht}===>${bldpur} What'll it be...:${txtrst}"
    read -n 1 choice
    echo
    choice=${choice:-1}   ## default to option 1

    case $choice in
        1)
        updt_cmd+="-u ${pacflag} "
        updt_msg="${bldwht}===> ${bldgrn}Updating the kernel and rebuilding Nvidia${txtrst}"
        rebuild=1  ;;
        2)
        updt_cmd+="-u ${pacflag} "
        updt_msg="${bldwht}===> ${bldgrn}Updating the kernel but not rebuilding Nvidia${txtrst}" ;;
        3)
        echo
        echo -en "${bldwht}===> ${bldgrn}Enter command (will be run verbatim): ${txtrst}"
        read updt_cmd
        updt_msg="${bldwht}===> ${bldgrn}Running ${updt_cmd}${txtrst}"
        echo -e " $(date +%d%m-%I)\n $updt_cmd" >> $updtfile 
        echo ;;
        4)
        unset updt_cmd
        return 1 ;;
    esac
}  # }}}

echo
echo -en "${bldwht}===>${bldgrn} Do you want to refresh the database? y/N "
read -n 1 ans
echo
[[ $ans == "y" ]] && sudo pacman-color -Syy

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

### ask if want to ignore any pkgs ###
echo
echo -e "${bldwht}===>${bldgrn} Do you want to: (1) run Normally${txtwht} (default) "
echo -e "${bldgrn}\t\t     (2) Force the update"
echo -e "${bldgrn}\t\t     (3) Ignore pkgs"
echo -e "${bldgrn}\t\t     (4) Both force & ignore"
echo -e "${bldgrn}\t\t     (5) Quit ${bldwht}"
echo -en "                     :"
read -n 1 for_ign
echo
case $for_ign in
1)
    echo ;;
2)
    updt_cmd+="-f "
    echo ;;
3)
    echo -en "${bldwht}===>${bldgrn} Enter the pkgs you want to ignore (comma separated):\n ${txtrst}"
    read ignpkg
    updt_cmd+="--ignore ${ignpkg} "
    echo ;;
4)
    echo -en "${bldwht}===>${bldgrn} Enter the pkgs you want to ignore (comma separated):\n ${txtrst}"
    read ignpkg
    updt_cmd+="-f --ignore ${ignpkg} "
    echo ;;
5)
    echo -e "${bldwht}===>${bldred} Goodbye\n"
    return 1 ;;
esac

### Check what needs to be updated ###
for u in ${updates[*]};do
    if [[  ${u} == 'linux' ]];then
        chkker=1
    fi
done

if [[ ${chkker} == "1" ]]; then
    declare -a others=(${updates[*]/linux/})
    [[ ${#others[*]} != 0 ]] && chkother=1
fi

### Do it ###
if [[ ${chkker} == "1" ]] && [[ ${chkother} != 1 ]] ; then
    ask_kern
elif  [[ ${chkother} == 1 ]];then
    ask_both
else updt_cmd+="-u "
     updt_msg="\n${bldwht}===>${bldblu}No kernel update found, performing full update${txtrst}"
fi

rolbak
echo -e "${updt_msg}\n"
${updt_cmd}
[[ ${rebuild} == "1" ]] && build_nvid
bkpkg

