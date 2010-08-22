'''
    PIMP: Package Installation & Management for Pedigree

    Copyright (c) 2010 Matthew Iselin

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

    pimp-makepkg: create a package
'''

import os
from optparse import OptionParser
import tarfile
import hashlib

optParser = OptionParser()
optParser.add_option("--path", dest="packagePath", help="""
    The PackagePath is the path to the files to be inserted into a package. This
    should be an exact layout of the filesystem as it would be in a Pedigree
    system - eg, binaries should be in PackagePath/applications, libraries in
    PackagePath/libraries, etc.""".replace("    ", "").strip())
optParser.add_option("--repo", dest="repoBase", help="""
    Path to the directory containing the local package repository. This will be
    where the new package will be created in. The package database should be in
    this directory (but use pimp-regpkg to register this package in the
    database.""".replace("    ", "").strip())
optParser.add_option("--name", dest="packageName", help="""
    The name of the package being created (necessary).""".replace("    ", "").strip())
optParser.add_option("--ver", dest="packageVersion", help="""
    The version of the package being created (necessary).""".replace("    ", "").strip())

(options, args) = optParser.parse_args()

repoBase = "./package_repo"
if options.repoBase <> None:
    repoBase = options.repoBase

if options.packagePath == None:
    print "You must specify a path to the package via the --path option."
    exit()
elif options.packageName == None:
    print "You must specify a name for the package via the --name option."
    exit()
elif options.packageVersion == None:
    print "You must specify a version for the package via the --ver option."
    exit()

packagePath = options.packagePath
packageName = options.packageName
packageVersion = options.packageVersion

if packagePath[-1] == "/":
    packagePath = packagePath[0:-1]

fileList = map(lambda x: packagePath + "/" + x, os.listdir(packagePath))

if len(fileList) == 0:
    print "The given package path has no files or directories in it."
    exit()

if not os.path.exists(repoBase):
    os.makedirs(repoBase)

# TODO: Error handling
packageOutput = repoBase + "/" + packageName + "-" + packageVersion + ".pimp"
tar = tarfile.open(packageOutput, "w:gz")

def filterfunc(x):
    x.name = os.path.basename(x.name)

for f in fileList:
    tar.add(f, arcname = os.path.basename(f))
tar.close()

print "Package '" + packageName + "-" + packageVersion + "' has now been created."
print "Run pimp-regpkg to register it in your package repository's database."

