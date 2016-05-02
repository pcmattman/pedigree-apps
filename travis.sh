#!/bin/sh

set -x
set -e

if [ "x$DEPS_ONLY$PACKAGE" = "x" ]; then
    ./runtests.sh
else
    if [ "x$TARGET" = "x" ]; then
        TARGET="amd64"
    fi

    if [ "$TARGET" = "amd64" ]; then
        echo "building for amd64"
        EASY_BUILD_TARGET="x64"
    else
        echo "building for $TARGET"
        EASY_BUILD_TARGET="$TARGET"
    fi

    # Build the standalone Pedigree needed for package building.
    # NOTE: this also creates a virtualenv if we aren't already in one.
    if [ "x$DEPS_ONLY" = "x" ]; then
        ./standalone.sh $EASY_BUILD_TARGET
    fi

    OPTS="--only-depends $PACKAGE"
    if [ "x$DEPS_ONLY" != "x" ]; then
        OPTS="--dryrun"
    fi

    # Build the specified package.
    ./buildPackages.sh "$TARGET" $OPTS

    if [ "x$DEPS_ONLY" != "x" ]; then
        dot -Tsvg dependencies.dot -o ./deps.svg
        python scripts/upload_deps.py $UPLOAD_KEY ./deps.svg $TARGET
    fi
fi
