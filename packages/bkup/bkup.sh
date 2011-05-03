#!/bin/bash
# Ver 123

bldgrn='\e[1;32m' # Green - bold
bldwht='\e[1;37m' # White - bold
BKUPDIR="/media/three/old-pkgs-etc"

echo -e "${bldgrn}==>${bldwht} Copying pacman cache to $BKUPDIR/my_pkgs. This may take a while"
cp -n /var/cache/pacman/pkg/* "$BKUPDIR"/pacman_pkgs/ || return 1
echo -en "${bldgrn}==>${bldwht} Do you want to copy your pkgs? "
read -n 1 ans1 
echo
if [ "$ans1" == "y" ]; then
	echo -en "${bldgrn}==>${bldwht} Again this may take a while....  Copying... "
	echo
	cp -n /projects/packages/* "$BKUPDIR"/my_pkgs/ || return 1
	cp -n /projects/src/* "$BKUPDIR"/src/ || return 1
	echo -en "${bldgrn}==>${bldwht} /projects/{packages,src} have been copied to "$BKUPDIR" "
	echo
fi
echo
echo -e "${bldgrn}    *******************************************"
echo -e "${bldgrn}    *     ${bldwht} Backup finished successfully  ${bldgrn}     *"
echo -e "${bldgrn}    *******************************************"
echo

