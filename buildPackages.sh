#!/bin/bash

BASEDIR=$PWD

# Pull out the architecture to build.
ARCH=$1
shift

# Please try and keep $DIRS sorted and categorised where possible.

# libtool gets its own category, as it needs to be run early
DIRS="$DIRS libtool"

# Put any dependent libraries before the applications that need them
DIRS="$DIRS zlib libiconv gettext libgmp libmpfr libmpc ncurses curl expat pth"
DIRS="$DIRS libpng libfreetype"

# Cross-compilers for special libraries
DIRS="$DIRS binutils gcc"

# Utilities
DIRS="$DIRS bsdtar coreutils diffutils e2fsprogs grep gnumake gzip inetutils"
DIRS="$DIRS m4 nano sed wget"

# Games
DIRS="$DIRS dosbox prboom"

# Programming languages (non-GCC)
DIRS="$DIRS lua nasm python26 python27"

# Other applications
DIRS="$DIRS apache2 bash lynx mtools"

# Apache modules
DIRS="$DIRS "

# Pedigree-specific stuff
DIRS="$DIRS pedigree-base"

echo > $BASEDIR/status.log

for f in $DIRS; do
    echo
    echo "---------- Building '$f' ----------"
    echo
    $BASEDIR/build.sh $ARCH $f $*

    if [ $? == 0 ]; then
        out="Success."
    else
        out="Failed."
    fi

    echo
    echo "$f: $out"
    echo "$f: $out" >> $BASEDIR/status.log
    echo
done

cd $BASEDIR

