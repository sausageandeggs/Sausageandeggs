#!/bin/bash

## Cowerd
## Ver 1.992
## A wrapper for Cower to build/update mutilple packages

. /usr/lib/sas/text-colors
unset build_opts
unset makecmd
unset targs
unset msg
instcmd=". PKGBUILD && sudo pacman-color -U --noconfirm --asdeps ${pkg_cache}\${pkgname}-\${pkgver}-\${pkgrel}-*.pkg.tar.xz "
pkg_cache="/media/arch/package-cache/"
cowercmd="cower -dft "
blddir="/projects/builds/"
build_opts="$1"
if [[ ! $build_opts =~ -d|-i|-ii|-m|-mm|-o|-u ]];then
    echo "  Usage: cowerd [-i|-ii|-m|-mm|-o|-d] [targets]"
    echo -e "\t cowerd -u"
    return 1
fi
shift

if [[ "$build_opts" == "-u" ]]; then
    echo -e "\n\t${bldylw}Updating all AUR packages${txtrst}"
    targs=($(cower -u --ignore=kernel26-ck,marlin-bin --nossl --color=never| awk '{print $2}'))
else
    targs=( $@ )
fi

#cower gets deps recursively so reverse results to make sure they're built in right order
get_targs() {
    sped=($(cower -ddft ${blddir} --color=never $@ | awk '{print $2}' ))
    deps=($(echo ${sped[*]} | tac -s ' '))
    deps=(${deps[*]/$i/})
}

case "$build_opts" in
    -d)
        msg="Getting PKGBUILD for" ;;
    -i)
        msg="Building and installing"
        makecmd="makepkg -isc --noconfirm" ;;
    -id | -di)
        msg="Building and installing as dependency"
        makecmd="makepkg -fsc --noconfirm" 
        asdeps="1" ;;
    -ii)
        msg="Building and installing (no cleanup)"
        makecmd="makepkg -is --noconfirm" ;;
    -m)
        msg="Building"
        makecmd="makepkg -cs" ;;
    -mm)
        msg="Building (no cleanup)"
        makecmd="makepkg -s" ;;
    -o)
        msg="Downloading sources for"
        makecmd="makepkg -o --noconfirm" ;;
    -u)
        msg="Updating"
        makecmd="makepkg -cis --noconfirm" ;;
esac

for i in ${targs[*]} ; do
    get_targs $i
    if [[ -n ${deps[*]} ]];then
        for j in ${deps[*]};do
            echo -e "\n\t ${bldgrn}Building and installing ${j} - a depdendency of ${i}${txtrst} \n"
            cd ${blddir}/${j} || return 1
            makepkg -cs
            eval ${instcmd}
        done
    fi
    echo -e "\n\t ${bldgrn}${msg} ${i}${txtrst} \n"
    cd ${blddir}/${i} || return 1
    ${makecmd}
    [[ -n ${asdeps} ]] && eval ${instcmd}

done

