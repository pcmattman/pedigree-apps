#!/bin/bash

package=mpfr
version=3.0.0

if [ -z $ENVPATH ]; then
    echo "ENVPATH not set, fixing" 1>&2
    ENVPATH=../..
fi

source $ENVPATH/environment.sh

BASE=$OUTPUT_BASE/$package/$version

# Remove existing files to force our updated version/link
[[ -e $CROSS_BASE/lib/libmpfr.a ]] && rm $CROSS_BASE/lib/libmpfr.a
[[ -e $CROSS_BASE/include/mpf2mpfr.h ]] && rm $CROSS_BASE/include/mpf2mpfr.h
[[ -e $CROSS_BASE/include/mpfr.h ]] && rm $CROSS_BASE/include/mpfr.h

ln -s $BASE/libraries/libmpfr.a $CROSS_BASE/lib/libmpfr.a
ln -s $BASE/include/mpf2mpfr.h $CROSS_BASE/include/mpf2mpfr.h
ln -s $BASE/include/mpfr.h $CROSS_BASE/include/mpfr.h
