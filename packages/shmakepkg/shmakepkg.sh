#!/bin/bash

# shmakepkg	{{{ 
# Ver 3
# Links $srcdir to /dev/shm or removes current link to /dev/shm
# and then calls makepkg with specified  options
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

srcdir=src # {{{
mkopts=$@
makepkg="makepkg $mkopts"
devshm=/dev/shm/$USER/makepkg/$pkgname
. PKGBUILD # }}}

shmake() { # {{{ 
	install -dm 700 $devshm
	ln -s $devshm $srcdir
	touch $srcdir/.tmpfs
	echo -e "${grn}==> ${ylw}$srcdir now links to ${pur}$devshm${rst}"
} # }}}

if [[ $@ == "-n" ]]; then 
	if [[ -e $srcdir && $(readlink $srcdir) != $devshm ]]; then
		echo -e "${grn}==>${red} Error, ${ylw}$srcdir${bld} exists but doesn't link to ${pur}$devshm${bld}"
		echo -en "${grn}==>${bld} Hit (y) to remove ${ylw}$srcdir${bld}, recreate, link to ${pur}$devshm${bld}.\n    Any other key to abort: "
		read -n 1 ans
		echo
		[[ $ans == y ]] && rm -rf $devshm $srcdir && shmake|| return 1
	elif [[ -e $srcdir && $(readlink $srcdir) == $devshm ]]; then
		echo -e "${grn}==> ${ylw}$srcdir${bld} already links to ${pur}$devshm${bld} :"
	else
		shmake
	fi
else
	if [[ -e $srcdir && $(readlink $srcdir) != $devshm ]]; then
		echo -e "${grn}==>${red} Error, ${ylw}$srcdir${bld} exists but doesn't link to ${pur}$devshm${bld}"
		echo -en "${grn}==>${bld} Hit (y) to remove ${ylw}$srcdir${bld}, recreate, link to ${pur}$devshm${bld} and continue build.\n    Any other key to abort: "
		read -n 1 ans
		echo
		[[ $ans == y ]] && rm -rf $devshm $srcdir && shmake && $makepkg|| return 1
	elif [[ -f $srcdir/.tmpfs ]]; then
		echo -en "${grn}==>${bld} Do you want to${grn} (1) ${bld}Delete ${ylw}$srcdir${bld} and ${pur}$devshm${bld} or${grn} (2) ${bld}Build ${cyn}$pkgname :"
		read -n 1 ans
		echo
		[[ $ans == 1 ]] && rm -rf $devshm $srcdir && \
			echo -e "${grn}==>${bld} Removed ${ylw}$srcdir and ${pur}$devshm${rst}"
		[[ $ans == 2 ]] && $makepkg
	else
		shmake 
	fi
fi
