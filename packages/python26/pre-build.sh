#!/bin/bash

source "$1/environment.sh"

set -e

cd "$2"
set -e
mkdir -p build && cd build

../configure

set +e
is_darwin=`uname -s | grep -i darwin`
set -e
pyext=""
if [ -z $is_darwin ]; then
    make python Parser/pgen
else
    make python.exe Parser/pgen
    pyext=".exe"
fi

mv python$pyext hostpython
mv Parser/pgen Parser/hostpgen

make distclean

cd ..
autoreconf

