#!/bin/bash

BASEDIR=$PWD

cd packages

# Put any dependent libraries before the applications that need them
# TODO: sort.
DIRS="zlib libiconv gettext libgmp libmpfr libmpc ncurses curl coreutils diffutils grep inetutils bsdtar e2fsprogs newlib bash m4 sed gzip nano nasm gnumake python lynx lua binutils gcc dosbox prboom wget"

echo > $BASEDIR/status.log

for f in $DIRS; do
    echo
    echo "---------- Building in directory $f ----------"
    echo
    ENVPATH=$BASEDIR $f/build.sh $*

    out="Failed."
    [[ $? ]] && out="Success."
    
    # Packages that provide headers or libraries that other packages need are
    # required to provide a "setupLinks.sh" script that automatically creates
    # links in the cross-compiler for the package (as packages may have different
    # layouts)
    if [ -e $f/setupLinks.sh ]; then    
        echo "    -> Linking to cross-compiler, future packages depend on '$f'"
        ENVPATH=$BASEDIR ./$f/setupLinks.sh
    fi

    echo
    echo "$f: $out"
    echo "$f: $out" >> $BASEDIR/status.log
    echo
done

cd $BASEDIR

