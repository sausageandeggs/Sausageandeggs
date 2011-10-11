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
unset cowercmd
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

get_targs() {
    sped=($(cower -ddf --color=never $@ | awk '{print $2}' ))
    deps=($(echo ${sped[*]} | tac -s ' '))
    #export ${deps[*]}
}

case "$build_opts" in
    -d)
        cowercmd="cower -f -d -t "
        msg="Getting PKGBUILD for" ;;
    -i)
        msg="Building and installing"
        cowercmd="cower -f -d -t "
        makecmd="makepkg -isc --noconfirm" ;;
    -id | -di)
        msg="Building and installing as dependency"
        makecmd="makepkg -fsc --noconfirm" 
        cowercmd="cower -f -d -t "
        instcmd="sudo pacman-color -U --noconfirm --asdep " ;;
    -ii)
        msg="Building and installing (no cleanup)"
        cowercmd="cower -f -d -t "
        makecmd="makepkg -is --noconfirm" ;;
    -m)
        msg="Building"
        cowercmd="cower -f -d -t "
        makecmd="makepkg -cs" ;;
    -mm)
        msg="Building (no cleanup)"
        cowercmd="cower -f -d -t "
        makecmd="makepkg -s" ;;
    -o)
        msg="Downloading sources for"
        cowercmd="cower -f -d -t "
        makecmd="makepkg -o --noconfirm" ;;
    -u)
        msg="Updating"
        cowercmd="cower -dft "
        makecmd="makepkg -ci --noconfirm" ;;
esac

for i in ${targs[*]} ; do
    #echo -e "\n\t ${bldgrn}Building ${i}${txtrst} \n"
    echo -e "\n\t ${bldgrn}${msg} ${i}${txtrst} \n"
    get_targs $i
    for j in ${deps[*]};do
        ${cowercmd} ${blddir} ${j} || return 1
        cd ${blddir}/${j} || return 1
        ${makecmd}
        [[ -n ${instcmd} ]] && ${instcmd} $j*
    done
done
