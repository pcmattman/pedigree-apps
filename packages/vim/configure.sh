#!/bin/bash

source ./package-info.sh

source "$1/environment.sh"

export CFLAGS
export CXXFLAGS
export CPPFLAGS
export LDFLAGS
export LIBS

set -e

cd "$2"

cd src
autoconf

./configure --host=$ARCH_TARGET-pedigree --bindir=/applications \
            --sysconfdir=/config/$package --datarootdir=/support/$package \
            --prefix=/support/$package --libdir=/libraries --includedir=/include \
            --with-tlib=ncurses --cache-file=auto/config.cache --enable-256-color

