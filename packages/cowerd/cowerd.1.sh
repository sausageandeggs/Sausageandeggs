#!/bin/bash

## Cowerd
## Ver 1.71
## A wrapper for Cower to build/update mutilple packages

. /usr/lib/sas/text-colors
unset build_opts
unset makecmd
unset instcmd
unset targs
unset msg
cowercmd="cower -f -d -t "
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

case "$build_opts" in
    -d)
        msg="Getting PKGBUILD for" ;;
    -i)
        msg="Building and installing"
        makecmd="makepkg -isc --noconfirm" ;;
    -id | -di)
        msg="Building and installing as dependency"
        makecmd="makepkg -fsc --noconfirm" 
        instcmd="sudo pacman-color -U --noconfirm --asdep " ;;
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
        makecmd="makepkg -ci --noconfirm" ;;
esac

for i in ${targs[*]} ; do
    #echo -e "\n\t ${bldgrn}Building ${i}${txtrst} \n"
    echo -e "\n\t ${bldgrn}${msg} ${i}${txtrst} \n"
    ${cowercmd} ${blddir} ${i} || return 1
    cd ${blddir}/${i} || return 1
    ${makecmd}
    [[ -n ${instcmd} ]] && ${instcmd} $i*
done
