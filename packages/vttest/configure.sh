#!/bin/bash

source ./package-info.sh

source "$1/environment.sh"

export CFLAGS
export CXXFLAGS
export LDFLAGS

set -e

cd "$2"
mkdir -p build && cd build

../configure --host=$ARCH_TARGET-pedigree --bindir=/applications \
             --sysconfdir=/config/$package --datarootdir=/support/$package \
             --prefix=/support/$package \
             > /dev/null 2>&1

