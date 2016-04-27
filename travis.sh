#!/bin/sh

set -x

if [ "x$PACKAGE" = "x" ]; then
    ./runtests.sh
else
    if [ "x$TARGET" = "x" ]; then
        TARGET="amd64"
    fi

    # Install compilers.
    sudo add-apt-repository -y ppa:miselin/pedigree-compilers
    sudo apt-get update
    sudo apt-get install travis-compilers

    # TODO: not needed once we hit 1.0.9....
    ln -s /home/travis/build/miselin/pedigree/pedigree-compiler $HOME/

    # Fix permissions on the compiler directories.
    ME=`whoami`
    sudo chown -R "$ME" /home/travis/build/miselin/pedigree/pedigree-compiler

    # Build the standalone Pedigree needed for package building.
    # NOTE: this also creates a virtualenv.
    ./standalone.sh

    # Build the specified package.
    ./buildPackages.sh "$TARGET" --only "$PACKAGE"

    # Show all logs.
    for f in packages/builds/logs/*.log; do
      echo "Logfile $f:"
      cat $f
    done
fi
