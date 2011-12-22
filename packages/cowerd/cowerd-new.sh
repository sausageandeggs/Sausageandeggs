#!/bin/bash

## Cowerd
## Ver 1.994
## Licensed under GPL2
## A wrapper for Cower to build/update mutilple packages

. /usr/lib/sas/text-colors
unset targs MSG flag deps sped UPDATE MAKECMD OPTIND LEAVE
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


while getopts ":dimoucfsh" flag ; do 
    case $flag in
        d)
            MSG="Getting PKGBUILD for"
            unset MAKECMD
            ;;
        i)
            MSG="Building and installing"
            MAKECMD="makepkg -i --noconfirm "
            LEAVE=1
            ;;
        m)
            MSG="Building"
            MAKECMD="makepkg "
            ;;
        o)
            MSG="Downloading sources for"
            MAKECMD="makepkg -o "
            ;;
        u)
            MSG="Updating"
            MAKECMD="makepkg -is --noconfirm "
            UPDATE=1
            LEAVE=1
            ;;
        c)
            MSG+=" (with cleanup)"
            MAKECMD+="-c "
            ;;
        f)
            MSG+=" (forcing)"
            MAKECMD+="-f "
            ;;
        s)
            MSG+=" (pulling in missing deps) "
            MAKECMD+="-s "
            ;;
        h)
            usage 
            ;;
        *)
            echo "Unrecognised option '$OPTARG'"
            usage
            return 1
            ;;
    esac
done
shift $((OPTIND-1))

if [[ $UPDATE == "1" ]]; then
    echo -e "\n\t${bldylw}Updating all AUR packages${txtrst}"
    targs=($(cower -u --ignore=kernel26-ck,marlin-bin --nossl --color=never| awk '{print $2}'))
else
    declare -a targs=("$@")
fi

for i in ${targs[*]} ; do
    get_targs ${i}
    if [[ -n ${deps[*]} ]];then
        for j in ${deps[*]};do
            echo -e "\n\t ${bldgrn}Building and installing ${j} - a depdendency of ${i}${txtrst} \n"
            cd ${blddir}${j} || return 1
            makepkg -cs
            install_built_package
            #eval ${instcmd}
            [[ $LEAVE == "1" ]] && cd -
        done
    fi
    echo -e "\n\t ${bldgrn}${MSG} ${i}${txtrst} \n"
    cd ${blddir}${i} || return 1
    ${MAKECMD}
    [[ -n ${asdeps} ]] && install_built_package #eval ${instcmd}
    [[ $LEAVE == "1" ]] && cd -

done

