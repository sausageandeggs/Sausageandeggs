#!/bin/bash
# Ver 1.2.1
# Copyright Simon Stoakley 2009,2010
# Script to backup pacmans cahe/entire package cache and creates an installed package list,
# also gives option to backup ABS pkgs & source files.

bldgrn='\e[1;32m' # Green - bold
bldwht='\e[1;37m' # White - bold
#set $1 as daymonthyear and $bkupdir var
set $(date +%d%m%y)
BKUPDIR=/media/three/archbkup_$1

if [[ $UID -ne 0 ]]; then           #check run as root
  echo "must be run as root"
  return 1
fi

#mount backup disk
#mount -t vfat /dev/sda3 /media/backup/ || return 1
#echo -e "${bldgrn}==>${bldwht} Mounted /dev/sda3 to /media/backup"

if [[ -d /media/three/oldbkup-no-3/ ]]; then
	echo -en "${bldgrn}==>${bldwht} Do you want to remove oldbkup-no-3? If not then it will be renamed to oldbkup-no-3`date +%j` Yes (y) or No (n)"
	read -n 1 ans2
	echo
	case $ans2 in
	   y)
	   echo -e "${bldgrn}==>${bldwht} removing oldbkup-no-3" 
	   rm -r /media/three/oldbkup-no-3 || return 1
	   ;;
	   n)
	   echo -e "${bldgrn}==>${bldwht} renaming oldbkup-no-3 to oldbkup-no-3`date +%j`"
	   mv /media/three/oldbkup-no-3{,`date +%j`} || return 1
	   ;;
	esac
fi
echo
echo -en "${bldgrn}==>${bldwht} Do you want to remove oldbkup-no-2? If not then it will be renamed to oldbkup-no-3. Yes (y) or No (n)"
read -n 1 ans
echo
case $ans in
   y)
   echo -e "${bldgrn}==>${bldwht} removing oldbkup-no-2" 
   rm -r /media/three/oldbkup-no-2 || return 1
   ;;
   n)
   echo -e "${bldgrn}==>${bldwht} renaming oldbkup-no-2 to oldbkup-no-3"
   mv /media/three/oldbkup-no-2 /media/three/oldbkup-no-3 || return 1
   ;;
esac
#move previous oldbackup
echo -e "${bldgrn}==>${bldwht} Previous oldbackup-no-1 is now in /media/three/oldbackup-no-2"
mv /media/three/oldbkup-no-1 /media/three/oldbkup-no-2 || return 1
#move old backup
mv /media/three/archbkup_* /media/three/oldbkup-no-1/ || return 1
echo -e "${bldgrn}==>${bldwht} Previous backup is now in /media/three/oldbackup-no-1"

#Make backup dir and start backup
mkdir $BKUPDIR || return 1
#backup list of installed packages
pacman -Qqe | grep -vx "$(pacman -Qqm)" > $BKUPDIR/$1_installed_pkg.list || return 1
#backup pacman database and creates installed pkg list
echo -e "${bldgrn}==>${bldwht} Tarring pacman local db to $BKUPDIR/-localdb-$1.tar.xz " 
tar -cJf $BKUPDIR/localdb-$1.tar.xz /var/lib/pacman/local/ 1>/dev/null 2>&1 || return 1

#backup pacman cache
echo -e "${bldgrn}==>${bldwht} Copying pacman cache to $BKUPDIR/$1-pkg-bkup. This may take a while"
cd /var/cache/ || return 1
#cp -r pacman/ $BKUPDIR/$1-pac-cache-pkg-bkup.tar.xz pkg/ || return 1
cp -r pacman/pkg $BKUPDIR/$1-pkg-bkup || return 1
echo -en "${bldgrn}==>${bldwht} Do you want to copy your ABS pkgs"
read -n 1 ans1 
echo
if [ "$ans1" == "y" ]; then
	echo -en "${bldgrn}==>${bldwht} Again this may take a while....  Copying... "
	cp -r /projects/packages $BKUPDIR/aur/my_pkgs/ 1>/dev/null 2>&1
	cp -r /projects/src $BKUPDIR/aur/my_src/ 1>/dev/null 2>&1
	cp -r /projects/builds/aur $BKUPDIR/aur/aur/ 1>/dev/null 2>&1
	echo -en "${bldgrn}==>${bldwht} /projects/{packages,src,aur} have been copied to $BKUPDIR"
	echo
fi
#echo -e "${bldgrn}==>${bldwht} Unmounting /dev/sda3"
#umount /dev/sda3
echo
echo -e "${bldgrn}    *******************************************"
echo -e "${bldgrn}    *     ${bldwht} Backup finished successfully  ${bldgrn}     *"
echo -e "${bldgrn}    *******************************************"
echo
echo -e "${bldgrn}==>${bldwht} Logging out of root"
echo
exit

