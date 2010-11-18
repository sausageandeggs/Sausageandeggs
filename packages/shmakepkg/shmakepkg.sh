#!/bin/bash

# shmakepkg	{{{
# Ver 2
# Links $srcdir to /dev/shm
# Usage: shmakepkg [usual makepkg options] }}}

red='\e[1;31m' # Red - bold {{{
grn='\e[1;32m' # Green - bold
ylw='\e[1;33m' # Yellow - bold
blu='\e[1;34m' # Blue - bold
wht='\e[1;37m' # White - bold
pur='\e[1;35m' # Purple
cyn='\e[1;36m' # Cyan
bld='\e[0m\033[1m' # plain bold
rst='\e[0m' # Txt reset }}}
srcdir=src # 																{{{
mkopts=$@
makepkg="makepkg $mkopts"
devshm=/dev/shm/$USER/makepkg/$pkgname # 									}}}

. PKGBUILD

if [[ -e $srcdir && $(readlink $srcdir) != $devshm ]]; then
	echo -e "${grn}==>${red} Error, ${ylw}$srcdir${bld} exists and doesn't link to ${pur}$devshm${bld}, aborting${rst}"; return 1
elif [[ -f $srcdir/.tmpfs ]]; then
	echo -en "${grn}==>${bld} Delete ${ylw}$srcdir${bld} and ${pur}$devshm${grn} (1)${bld} or Build ${cyn}$pkgname ${grn}(2)${rst}:"
	read -n 1 ans
	echo
	[[ $ans == 1 ]] && rm -rf $devshm $srcdir && \
		echo -e "${grn}==>${bld} Success, Removed ${ylw}$srcdir and ${pur}$devshm${rst}"
	[[ $ans == 2 ]] && $makepkg
else
	install -dm 700 $devshm
	ln -s $devshm $srcdir
	touch $srcdir/.tmpfs
	echo -e "${grn}==>${bld} Success, ${ylw}$srcdir linked to ${pur}$devshm${rst}"
	$makepkg
fi
