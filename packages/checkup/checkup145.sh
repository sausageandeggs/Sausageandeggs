#!/bin/bash
#
# Checkup Ver 1.4.6
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
# along with checkup.  If not, see <http://www.gnu.org/licenses/>.

bldred='\e[1;31m' # Red - bold
bldgrn='\e[1;32m' # Green - bold
bldylw='\e[1;33m' # Yellow - bold
bldblu='\e[1;34m' # Blue - bold
bldwht='\e[1;37m' # White - bold
txtrst='\e[0m' # Txt reset
chkker=""
chknvid=""
chkother=""
set ""

bkpkg () {
	echo
	echo -e "${bldwht}===>${bldgrn} Backing up local database"
	mv /media/three/local_bkup/{local-*,old}
	tar -cJf /media/three/local_bkup/local-`date +%d%m`.tar.xz /var/lib/pacman/local/ 1>/dev/null 2>&1 || return 1
	rm /media/three/local_bkup/old
	echo
}

if [[ $UID -eq 0 ]]; then           
	echo -e "${bldwht}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo -e "${bldwht}##${bldred} Don't run this as root${bldwht} ##"
	echo -e "${bldwht}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	return 1
fi

echo
echo -en "${bldwht}===>${bldgrn} Do you want to refresh the database? Yes (y) or No (n) "
read -n 1 ans
echo
if [[ $ans == "y" ]]; then
	sudo pacman-color -Sy
fi

numb=`/usr/lib/sas/numpkg.sh output` 	## not really needed but just makes easier reading
##See if there are any updates at all##
set `pacman -Qu | awk '{print $1}'` 1>/dev/null 2>&1
if [[ -z $@ ]]; then
	echo -en "${bldwht}===>${bldred} You are up to date. Exiting in 5"
	sleep 1 && echo -en "${bldred}\b4"
	sleep 1 && echo -en "${bldred}\b3"
	sleep 1 && echo -en "${bldred}\b2"
	sleep 1 && echo -en "${bldred}\b1"
	sleep 1 && echo -en "${bldred}\b0"
	echo
	return 1
fi

echo
if [[ $numb == "one" ]]; then
	echo -e "${bldwht}===>${bldgrn} There is $numb package to update"
  else
	echo -e "${bldwht}===>${bldgrn} There are $numb packages to update"
fi
echo
#####setting pkg updates display so that old --> new is displayed###
cd /var/lib/pacman/sync
for i in $@ ;do
	 echo -e "    ${bldwht} `pacman -Qu | grep -m 1 ^$i ` ${bldgrn}-->${bldwht} `ls -l * | awk '{print $9}' | grep  -m 1 ^$i-[0-9]`" 
done
cd /home/sas/ 1>/dev/null
######## ask if want to ignore any pkgs ####
echo
echo -en "${bldwht}===>${bldgrn} Do you want to ignore any pkgs, kernel pkgs will automatically be ignored if theres no nvidia pkg. Yes (y) or No (n): ${bldwht}"
read -n 1 ans4
echo
if [[ "$ans4" == "y" ]];then
	echo -en "${bldwht}===>${bldgrn} Enter the pkgs you want to ignore (comma separated): ${bldwht}"
	read ignpkg
	echo -e "${txtrst}"
fi
######check what needs to be updated#####
case "$@" in
	*kernel*)			#look for a kernel update
		chkker=1
esac

if [ "$chkker" == "1" ]; then
	case "$@" in			#if theres a kernel look for an nvidia pkg
		*nvidia*)
			chknvid=1
		;;
		*)		#if theres no nvidia pkg, check for other updates
		if [[ -z "$chknvid" ]]; then
			declare -a chkother=`pacman -Qu | grep -v nvidia | grep -v kernel | awk '{print $1}'`
		fi
	esac
fi
### Decide what to do ##### 
if [ "$chknvid" == "1" ]; then
	echo
	echo -e "${bldwht}===>${bldblu} both kernel and Nvidia pkg's found, do you want to update?"
 elif [ -z "$chkker" ]; then
	echo
	echo -e "${bldwht}===>${bldblu} No kernel pkg, do you want to update?"
 elif [[ ! -z ${chkother[*]} ]]; then
	echo
	echo -e "${bldwht}===>${bldylw} There is a kernel pkg with no Nvidia pkg, but there are other packages that are safe to update." 
	echo -e "\t ${bldylw}Do you want to..."
	echo -e "\t ${bldwht}(a)${bldylw} Update skiping the kernel pkg." 
	echo -e "\t ${bldwht}(b)${bldylw} Update the kernel as well." 
	echo -e "\t ${bldwht}(c)${bldylw} Update the kernel then build and install a new Nvidia pkg with Bauerbill."
	echo -e "\t ${bldwht}(d)${bldylw} Do nothing and exit."
	echo -e "\t ${txtylw}(Any pkgs you want to ignore will be ignored whatever choice is made)"
	echo -en "${bldwht}===>${bldylw} What'll it be...... (a) (b) (c) or (d) ?"
	read -n 1 ans2
	echo			## Do what needs to be done ##
	case $ans2 in
		a)
		if [[ "$ans4" == "y" ]];then				#check for manually ignored packages
			echo -e "${bldwht}===>${bldgrn} These pkgs will also be ignored${bldwht} $ignpkg"
			echo -e "${txtrst}"
			sudo pacman-color  -Su --ignore kernel26-headers,kernel26,kernel26-lts,kernel26-lts-headers,kernel26-firmware,$ignpkg
			bkpkg
			return 1
		fi
		sudo pacman-color -Su --ignore kernel26-headers,kernel26,kernel26-lts,kernel26-lts-headers,kernel26-firmware
		bkpkg
		return 1
		;;
		d)
		echo -en "${bldwht}===>${bldred} Exiting in 5"
		sleep 1 && echo -en "${bldred}\b4"
		sleep 1 && echo -en "${bldred}\b3"
		sleep 1 && echo -en "${bldred}\b2"
		sleep 1 && echo -en "${bldred}\b1"
		sleep 1 && echo -en "${bldred}\b0"
		echo
		return 1
		;;
		b)
		if [[ "$ans4" == "y" ]];then			
			echo -e "${bldwht}===>${bldgrn} These pkgs will also be ignored${bldwht} $ignpkg"
			echo -e "${txtrst}"
			sudo pacman-color  -Su --ignore $ignpkg
			bkpkg
			return 1
		fi
		sudo pacman-color -Su
		bkpkg
		echo
		return 1
		;;
		c)						## updates fully then calls bauerbill to
		if [[ "$ans4" == "y" ]]; then		## build + install nvidia pkg
			sudo pacman-color -Su $ignpkg
		elif [[ "$ans4" == "n" ]]; then
			sudo pacman-color -Su
		fi 
		sudo pacman -Rd nvidia-beta nvidia-utils-beta
		sudo bauerbill -S nvidia-beta nvidia-utils-beta
		bkpkg
		return 1
		;;
	esac
  else
	echo -e "${bldwht}===>${bldred} You need to wait for the Nvidia package to update before updating" 
	echo -en "${bldwht}===>${bldred} Exiting in 5"
	sleep 1 && echo -en "${bldred}\b4"
	sleep 1 && echo -en "${bldred}\b3"
	sleep 1 && echo -en "${bldred}\b2"
	sleep 1 && echo -en "${bldred}\b1"
	sleep 1 && echo -en "${bldred}\b0"
	echo
	return 1
fi

echo -en "${bldwht}===>${bldblu} Yes (y) No (n)  "
read -n 1 ans
echo
echo
case $ans in
	y)						
	if [[ "$ans4" == "y" ]];then				
		echo -e "${bldwht}===>${bldgrn} These pkgs will also be ignored${bldwht} $ignpkg "
		echo -e "${txtrst}"
		sudo pacman-color  -Su --ignore $ignpkg
		bkpkg
		return 1
	fi
	sudo pacman-color -Su
	bkpkg
	;;
	n)
	echo -en "${bldwht}===>${bldred} Exiting in 5"
	sleep 1 && echo -en "${bldred}\b4"
	sleep 1 && echo -en "${bldred}\b3"
	sleep 1 && echo -en "${bldred}\b2"
	sleep 1 && echo -en "${bldred}\b1"
	sleep 1 && echo -en "${bldred}\b0"
	echo
	return 1
esac




pacman -Qs nvidia | grep nvidia | grep -v beta

