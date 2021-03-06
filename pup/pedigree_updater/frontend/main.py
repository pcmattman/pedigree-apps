#!/usr/bin/env python
'''
PUP: Pedigree UPdater

Copyright (c) 2015 Matthew Iselin

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
'''

import argparse
import logging

from pedigree_updater.commands import base
from pedigree_updater.lib import util


log = logging.getLogger()


def main():
    cmds = [klass() for klass in base.PupCommand.__subclasses__()]
    cmds = {k.name(): k for k in cmds}

    parser = argparse.ArgumentParser(description='The Pedigree UPdater.')
    parser.add_argument('--config', type=str, help='path to config file.')

    subparsers = parser.add_subparsers(title='pup commands', dest='which')
    for cmd in cmds.values():
        if cmd.name() is None:
            continue

        group = subparsers.add_parser(cmd.name(), help=cmd.help())
        cmd.add_arguments(group)

    args = parser.parse_args()

    logging.basicConfig(level=logging.DEBUG)

    # Remove informational logging from requests & urllib3, which leaks more
    # data than is desirable.
    logging.getLogger('requests').setLevel(logging.WARNING)
    logging.getLogger('urllib3').setLevel(logging.WARNING)

    if not args.which:
        parser.print_help()
        exit(1)

    config = util.load_config(args)
    if not config:
        exit(1)

    cmd = cmds[args.which]
    if cmd.run(args, config):
        exit(1)


if __name__ == '__main__':
    main()
