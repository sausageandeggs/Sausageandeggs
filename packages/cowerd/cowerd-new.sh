#!/bin/bash

## Cowerd
## Ver 1.995
## Licensed under GPL2
## A wrapper for Cower to build/update mutilple packages

. /usr/lib/sas/text-colors
pkg_cache="/media/arch/package-cache/"
COWERCMD="cower -b --nossl --color=never -f -t \${blddir} -d"
flag=0
deps=0
sped=0
targs=0
BUILD_DEPS=0
LEAVE=0
MAKECMD=0
MSG=0
OPTIND=0
UPDATE=0

usage(){ # {{{
    cat << EOF

    cowerd [Operation] [OPTIONS] TARGETS
    cowerd -u

    [Operation]
    -d        download AUR tarball only
    -i        build & install pkg
    -m        build pkg only
    -o        download & extract source only

    -u        update all installed foriegn pkgs (no TARGETS needed)

    [Options]
    -c        clean after build
    -f        force build
    -s        build and install deps
    -t <DIR>  specify build directory (default "/projects/builds/"

    -h        this message
EOF
} # }}}

install_built_package(){ # {{{
    . PKGBUILD
    sudo pacman-color -U --noconfirm --asdeps ${pkg_cache}${pkgname}-${pkgver}-${pkgrel}-*.pkg.tar.xz
} # }}}

get_deps() { # {{{
#cower gets deps recursively so reverse results to make sure they're built in right order
    sped=( $( ${COWERCMD} ${targs[*]} | awk '{print $2}' ) )
    deps=($(echo ${sped[*]} | tac -s ' ' ))
    for h in ${targs[*]};do
        deps=(${deps[*]/$h/})
    done
} # }}}

while getopts ":dimoucfsht:" flag ; do # {{{
    case $flag in
        d)
            MSG="Getting PKGBUILD for"
            MAKECMD="echo -e ${bldgrn}Done${txtrst}"
            ;;
        i)
            MSG="Building and installing"
            MAKECMD="makepkg -i --noconfirm"
            LEAVE=1
            ;;
        m)
            MSG="Building"
            MAKECMD="makepkg"
            ;;
        o)
            MSG="Downloading sources for"
            MAKECMD="makepkg -o"
            ;;
        u)
            COWERCMD+=" -u --ignore=kernel26-ck,marlin-bin"
            MSG="Updating all AUR packages"
            MAKECMD="makepkg -is --noconfirm"
            UPDATE=1
            LEAVE=1
            ;;
        c)
            MSG+=" (with cleanup)"
            MAKECMD+=" -c "
            ;;
        f)
            MSG+=" (forcing)"
            MAKECMD+=" -f "
            ;;
        s)
            COWERCMD+=" -d"
            MSG+=" (pulling in missing deps) "
            MAKECMD+=" -s "
            BUILD_DEPS=1
            ;;
        t)
            blddir="$OPTARG"
            ;;
        h)
            usage 
            ;;
        *)
            echo "Unrecognised option "$OPTARG""
            usage
            return 1
            ;;
    esac
done
shift $((OPTIND-1))  #}}}

blddir="${blddir:-/projects/builds/}"

if [[ $UPDATE == "1" ]]; then
    echo -e "\n\t${bldylw}Updating all AUR packages${txtrst}"
    targs=($(cower -qu --ignore=kernel26-ck,marlin-bin --nossl --color=never))
else
    declare -a targs=("$@")
fi

[[ BUILD_DEPS == "1" ]] && get_deps ${targs}

for i in ${targs[*]} ; do
    [[ BUILD_DEPS == "1" ]] && get_deps ${i}
    if [[ -n ${deps[*]} ]];then
        for j in ${deps[*]};do
            echo -e "\n\t ${bldgrn}Building and installing ${j} - a depdendency of ${i}${txtrst} \n"
            cd ${blddir}${j} || return 1
            ${MAKECMD}
            install_built_package
            [[ $LEAVE == "1" ]] && cd -
        done
    fi
    echo -e "\n\t ${bldgrn}${MSG} ${i}${txtrst} \n"
    cd ${blddir}${i} || return 1
    ${MAKECMD}
    [[ -n ${asdeps} ]] && install_built_package
    [[ $LEAVE == "1" ]] && cd -
done

