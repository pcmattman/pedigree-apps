#!/bin/bash

# Standalone pedigree-apps prepare - builds a local Pedigree build and then
# writes out a local configuration that uses that build directly. This allows
# the pedigree-apps build to be completely self-contained.

# TODO(miselin): assumes running on a build slave
# TODO(miselin): assumes Debian as the host system

# Abort the build immediately if anything goes wrong.
set -e

UNPRIV_UID=$(id -u $USER)
UNPRIV_GID=$(id -g $USER)

LOCALDIR="$PWD"

# Make sure we're in the pedigree-apps root.
if [ ! -e "./buildPackages.py" ]; then
    echo "Must be run in pedigree-apps root directory." 1>&2
    exit 1
fi

# Grab architecture for building.
EASY_BUILD_TARGET=$1
if [ "x$EASY_BUILD_TARGET" = "x" ]; then
    EASY_BUILD_TARGET=x64
fi

mkdir -p standalone && cd standalone

# Create a Python virtual environment if one doesn't exist yet.
# NOTE: if we're already in one, don't bother (no need).
if [ "x$VIRTUAL_ENV" = "x" ]; then
    if [ ! -e "venv" ]; then
        virtualenv --system-site-packages venv
    fi
fi

# Grab Pedigree first.
if [ ! -e "pedigree" ]; then
    git clone --depth 1 https://github.com/miselin/pedigree.git
fi

# Go ahead and build it.
cd pedigree
git pull
rm -f .easy_os  # Make sure we retry downloading packages.

# Don't do custom behaviour on travis for the standalone build.
if [ "x$TRAVIS" != "x" ]; then
    cat <<EOF >./build-etc/travis.sh
#!/bin/bash
TRAVIS_OPTIONS="forcemtools=1"
EOF
fi
./easy_build_$EASY_BUILD_TARGET.sh noconfirm debian build_images=0
cd ..

# Create our local configuration, ready to ship.
cd ..
cat >local_environment.py <<EOF

import functools

from support.util import expand


def modify_environment(env):
    _expand = functools.partial(expand, env)
    env['PEDIGREE_BASE'] = _expand('$LOCALDIR/standalone/pedigree')
    env['APPS_BASE'] = _expand('$LOCALDIR')
    env['CCACHE_TARGET_DIR'] = '/mnt/ram/ccache'

    env['UNPRIVILEGED_GID'] = '$UNPRIV_GID'
    env['UNPRIVILEGED_UID'] = '$UNPRIV_UID'

EOF

# Done. All set to go now.
echo "Standalone preparation is now complete."
