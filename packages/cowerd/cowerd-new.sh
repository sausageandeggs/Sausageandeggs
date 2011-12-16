#!/bin/bash

## Cowerd
## Ver 1.993
## A wrapper for Cower to build/update mutilple packages

. /usr/lib/sas/text-colors
unset build_opts
makecmd="makepkg "
unset targs
unset msg

pkg_cache="/media/arch/package-cache/"
cowercmd="cower -dft "
blddir="/projects/builds/"

usage(){ # {{{
    cat << EOF
    cowerd [FLAGS] [OPTIONS] TARGETS
    cowerd -u

    [Flags]
    -d download AUR tarball only
    -i build & install pkg
    -m build pkg only
    -o download & extract source only

    -u update all installed foriegn pkgs (no TARGETS needed)

    [Options]
    -c clean after build
    -f force build
    -s build and install deps

    -h this message
EOF
} # }}}

install_built_package(){ # {{{
    . PKGBUILD
    sudo pacman-color -U --noconfirm --asdeps ${pkg_cache}\${pkgname}-\${pkgver}-\${pkgrel}-*.pkg.tar.xz
} # }}}

get_targs() { # {{{
#cower gets deps recursively so reverse results to make sure they're built in right order
    sped=($(cower -ddft ${blddir} --color=never $@ | awk '{print $2}' ))
    deps=($(echo ${sped[*]} | tac -s ' '))
    deps=(${deps[*]/$i/})
} # }}}


while getopts "dfimnosu" OPTION
do
    case "$build_opts" in

        -c)
            msg=""
            makecmd+="-c " ;;
        -d)
            msg="Getting PKGBUILD for" ;;
        -i)
            msg="Building and installing"
            makecmd+="-is --noconfirm " ;;
        -id | -di)
            msg="Building and installing as dependency"
            makecmd+="-f --noconfirm " 
            asdeps="1" ;;
        -f)
            msg="Building and installing (no cleanup)"
            makecmd+="-f " ;;
        -m)
            msg="Building"
            makecmd+="" ;;
        -s)
            msg="Building (cleanup)"
            makecmd+="-c " ;;
        -o)
            msg="Downloading sources for"
            makecmd+="-o " ;;
        -u)
            msg="Updating"
            makecmd+="-is --noconfirm "
            UPDATE=1 ;;
    esac
done
shift $((OPTIND-1))

if [[ "$UPDATE" == "1" ]]; then
    echo -e "\n\t${bldylw}Updating all AUR packages${txtrst}"
    targs=($(cower -u --ignore=kernel26-ck,marlin-bin --nossl --color=never| awk '{print $2}'))
else
    targs=( $@ )
fi

for i in ${targs[*]} ; do
    get_targs $i
    if [[ -n ${deps[*]} ]];then
        for j in ${deps[*]};do
            echo -e "\n\t ${bldgrn}Building and installing ${j} - a depdendency of ${i}${txtrst} \n"
            cd ${blddir}/${j} || return 1
            makepkg -cs
            install_built_package
            #eval ${instcmd}
        done
    fi
    echo -e "\n\t ${bldgrn}${msg} ${i}${txtrst} \n"
    cd ${blddir}/${i} || return 1
    ${makecmd}
    [[ -n ${asdeps} ]] && install_built_package #eval ${instcmd}

done

