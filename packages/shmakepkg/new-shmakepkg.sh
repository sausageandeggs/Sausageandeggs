#!/bin/bash

grn='\e[1;32m' # Green - bold {{{
pur='\e[1;35m' # Purple
cyn='\e[1;36m' # Cyan
bld='\e[0m\033[1m' # plain bold
rst='\e[0m' # Txt reset

srcdir=src
mkopts=$@
makepkg="makepkg $mkopts"
devshm=/dev/shm/$USER/makepkg/$pkgname
. PKGBUILD # }}}

#find directory type
[[ -e "$srcdir" && $(readlink "$srcdir") != "$devshm" ]] && dirtype="N"
[[ -e "$srcdir" && $(readlink "$srcdir") == "$devshm" ]] && dirtype="L"
#build in shared mem or not ?
#echo -en "${grn}==>${bld} Build in shared mem? (y) or (n) :${rst}"
#read -n 1 bldshm
#echo

#[[ "$bldshm" == "n" && "$dirtype" == "L" ]] && rm -rf "$devshm" "$srcdir"

#if [[ "$bldshm" == "y" ]];then
if [[ "$dirtype" == "N" ]]; then rm -rf "$devshm" "$srcdir" ; fi
install -dm 700 "$devshm"
ln -s "$devshm" "$srcdir"
touch "$srcdir"/.tmpfs
echo -e "${grn}==> ${cyn}$srcdir${bld} now links to ${pur}$devshm${rst}"
#fi

$makepkg

