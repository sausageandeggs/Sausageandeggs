#!/bin/bash

# {{{ Not root check
if [[ $UID -eq 0 ]]; then           
	echo -e "${bldwht}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo -e "${bldwht}##${bldred} Don't run this as root${bldwht} ##"
	echo -e "${bldwht}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	return 1
fi # }}}

# {{{ Blurb
# Checkup Ver 2.0b
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

# Variables {{{ 
bldred='\e[1;31m' # Red - bold
bldgrn='\e[1;32m' # Green - bold
bldylw='\e[1;33m' # Yellow - bold
bldblu='\e[1;34m' # Blue - bold
bldwht='\e[1;37m' # White - bold
txtrst='\e[0m' # Txt reset
chkker=""
chknvid=""
chkother=""
oldver=""
updtfile="/media/three/local_bkup/updatedpgks.log"
pacfirm="$1"
pacflag="--noconfirm"
[[ $pacfirm == "-c" ]] && pacflag=""
ppp="sudo powerpill -Su $pacflag"
set ""
# }}}

bkpkg () { # {{{
	echo
	echo -e "${bldwht}===>${bldgrn} Backing up local database"
	mv /media/three/local_bkup/{old.tar.xz,done.tar.xz} || return 1
	mv /media/three/local_bkup/{local-*,old.tar.xz} || return 1
	tar -cJf /media/three/local_bkup/local-$(date +%d%m).tar.xz /var/lib/pacman/local/ 1>/dev/null 2>&1 || return 1
	rm /media/three/local_bkup/done.tar.xz
	echo
}
# }}}

echo
echo -en "${bldwht}===>${bldgrn} Do you want to refresh the database? Yes (y) or No (n) "
read -n 1 ans
echo
if [[ $ans == "y" ]]; then
	sudo pacman-color -Syy
fi

numb=$(/usr/lib/sas/numpkg.sh output) 	## not really needed but just makes easier reading

##See if there are any updates at all and list them##
set $(pacman -Qu | awk '{print $1}') 1>/dev/null 2>&1

if [[ -z $@ ]]; then
echo -en "${bldwht}===>${bldred} You are up to date."
return 1
fi

#echo
if [[ $numb == "one" ]]; then
	echo -e "${bldwht}===>${bldgrn} There is $numb package to update"
  else
	echo -e "${bldwht}===>${bldgrn} There are $numb packages to update"
fi
echo

# Print updates (old --> new) {{{
declare -a vers=($(pacman -Qu | awk '{print $1}'))
a=0
b=0
c=0
WW="$(( $COLUMNS/2 - 2 ))"

for i in ${vers[*]};do
	declare -a oldver[$a]="$(expac '%n-%v' -s ${vers[$a]} | grep -m 1 ${vers[$a]})"
	(( a++ ))
done
for j in ${vers[*]};do
	declare -a newver[$b]="$(expac '%n-%v' -Ss ${vers[$b]} | grep -m 1 ${vers[$b]})"
	(( b++ ))
done
for k in ${vers[*]};do
	printf "%${WW}b %b %b\n" "${bldwht}${oldver[$c]}" "${bldgrn}-->" "${bldwht}${newver[$c]}"
	#echo -e "${bldwht} ${oldver[$c]} ${bldgrn}--> ${bldwht}${newver[$c]}${txtrst}"
	(( c++ ))
done #}}}

#### --noconfirm msg ####
if [[ "$pacfirm" != "-c" ]] ;then
	echo -e "${bldwht}===>${bldylw} Pacman will be called with the '--noconfirm' flag, call checkup with the '-c' flag to prevent this${bldwht}"
fi
######## ask if want to ignore any pkgs ####
echo
echo -e "${bldwht}===>${bldgrn} Do you want to: (i) Ignore pkgs"
echo -e "${bldwht}===>${bldgrn}		     (f) Force an update"
echo -e "${bldwht}===>${bldgrn}		     (b) Both force & ignore"
echo -e "${bldwht}===>${bldgrn}		     (r) Run a custom cmd" 
echo -e "${bldwht}===>${bldgrn}		     (N) run Normally"
echo -e "${bldwht}===>${bldgrn}		     (q) Quit ${bldwht}"
echo -en "                     :"
read -n 1 ans4
echo
if [[ "$ans4" == "q" ]]; then
  echo -e "${bldwht}===>${bldred} Goodbye"
  return 1
elif [[ "$ans4" == "r" ]];then
        echo "Enter  command: "
        read ppp
		echo -e " $(date +%d%m-%I)\n $ppp" >> $updtfile 
        echo
        sudo $ppp
        return 1    ### Set ignore or both, gets ignore element of both
elif [[ "$ans4" == "i" ]] || [[ "$ans4" == "b" ]];then
	echo -en "${bldwht}===>${bldgrn} Enter the pkgs you want to ignore (comma separated): ${bldwht}"
	read ignpkg
	echo -e "${txtrst}"
fi

#Grab a list of updated pkgs for easy copy paste rollback                        
rolbak() { 	# {{{
	echo
	echo -en "${bldwht}===>${bldgrn} Creating updated package list for easy rollback"
	echo
# add $pkgver-$arch-pkg,tar.*z and put everything on 1 line
	oldver=$(pacman -Qu | sed 's|\ |-|g')
	co=0
	declare -a oldvers=""
	for i in $oldver;do 
	oldvers[$co]=$(ls -l /var/cache/pacman/pkg/$i* | cut -d/ -f6) #1>> $updtfile
	(( co++ ))
done
	echo $(date +%d%m-%I) >> $updtfile
	echo ${oldvers[*]} >> $updtfile
} # }}}

### Set force or both, gets force element of both
if [[ "$ans4" == "f" ]] || [[ "$ans4" == "b" ]];then
    ppp="sudo pacman -Suf ${pacflag}"
fi

######check what needs to be updated#####
case "$@" in
	*kernel*)			#look for a kernel update
		chkker=1
esac

if [[ "$chkker" == "1" ]]; then
    set $(echo $@ | sed s/lib32-nvidia-utils//)
    case "$@" in			#if theres a kernel look for an nvidia pkg excl 32b nvids
		*nvidia*)   
	       	chknvid=1
		;;
		*)		#if theres no nvidia pkg, check for other updates
		if [[ -z "$chknvid" ]]; then
            declare -a chkother=$(pacman -Qu | grep -v nvidia | grep -v kernel | awk '{print $1}')
		fi
	esac
fi

### Decide what to do ##### 
if [[ "$chknvid" == "1" ]]; then
	echo
	echo -e "${bldwht}===>${bldblu} Both kernel and Nvidia updates found, proceeding"
 elif [[ -z "$chkker" ]]; then
	echo
	echo -e "${bldwht}===>${bldblu} No kernel update, proceeding"
 elif [[ ! -z ${chkother[*]} ]]; then
	echo
	echo -e "${bldwht}===>${bldylw} There is a kernel pkg with no Nvidia pkg, but there are other packages that are safe to update." 
	echo -e "\t ${bldylw}Do you want to..."
	echo -e "\t ${bldwht}(a)${bldylw} Update skiping the kernel pkg." 
	echo -e "\t ${bldwht}(b)${bldylw} Update everything." 
	echo -e "\t ${bldwht}(c)${bldylw} Update the kernel then build a new Nvidia pkg against it"
	echo -e "\t ${bldwht}(d)${bldylw} Run a custom command."
	echo -e "\t ${bldwht}(e)${bldylw} Do nothing and exit."
	echo -e "\t ${txtylw}(Any pkgs you want to ignore will be ignored whatever choice is made)"
    echo -en "${bldwht}===>${bldylw} What'll it be......"
	read -n 1 ans2
	echo			## Do what needs to be done ##
	case $ans2 in
		a)
		if [[ "$ans4" == "i" ]] || [[ "$ans4" == "b" ]];then				#check for manually ignored packages
			echo -e "${bldwht}===>${bldgrn} These pkgs will also be ignored${bldwht} $ignpkg"
			echo -e "${txtrst}"
			echo "kernel pkgs not updated"
			rolbak
			$ppp --ignore kernel26-headers,kernel26,kernel26-lts,kernel26-lts-headers,kernel26-firmware,$ignpkg
			bkpkg
			return 1
		fi
		echo "kernel pks not updated"
		rolbak
		$ppp --ignore kernel26-headers,kernel26,kernel26-lts,kernel26-lts-headers,kernel26-firmware
		bkpkg
		return 1
		;;
		b)
		if [[ "$ans4" == "i" ]] || [[ "$ans4" == "b" ]];then			
			echo -e "${bldwht}===>${bldgrn} These pkgs will also be ignored${bldwht} $ignpkg"
			echo -e "${txtrst}"
			rolbak
			$ppp --ignore $ignpkg
			bkpkg
			return 1
		fi
		rolbak
		$ppp
		bkpkg
		echo
		return 1
		;;
		c)						## updates fully then calls bauerbill to
		if [[ "$ans4" == "i" ]] || [[ "$ans4" == "b" ]]; then		## build + install nvidia pkg
			rolbak
			$ppp $ignpkg
        else
			rolbak
			$ppp
		fi 
		cd /projects/builds/nvidia-beta-all
		makepkg
		cd -
		bkpkg
		return 1
		;;
		d)
        echo -e "\tEnter command :"
        read ppp
        echo
		rolbak
        sudo $ppp
        return 1
        ;;
		e)
        return 1
		;;
	esac
  else
	echo -e "${bldwht}===>${bldred} You need to wait for the Nvidia package to update before updating" 
    return 1
fi

if [[ "$ans4" == "i" ]] || [[ "$ans4" == "b" ]];then				
	echo -e "${bldwht}===>${bldgrn} These pkgs will also be ignored${bldwht} $ignpkg "
	echo -e "${txtrst}"
	rolbak
	$ppp --ignore $ignpkg
	bkpkg
	return 1
fi
rolbak
$ppp
bkpkg
return 1
