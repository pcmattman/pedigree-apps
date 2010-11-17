#!/bin/bash

source ./package-info.sh

source "$1/environment.sh"

set -e

cd "$2"

make INSTALL_TOP="$out/" \
     INSTALL_BIN="$out/applications" \
     INSTALL_LIB="$out/libraries" \
     INSTALL_LMOD="$out/support/lua/share/5.1" \
     INSTALL_CMOD="$out/libraries/lua/5.1" \
     install > /dev/null 2>&1
