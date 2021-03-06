
import os

from support import buildsystem
from support import steps


class GlibPackage(buildsystem.Package):

    def __init__(self, *args, **kwargs):
        super(GlibPackage, self).__init__(*args, **kwargs)
        self._options = buildsystem.Options()
        self._options.tarfile_format = 'xz'

    def name(self):
        return 'glib'

    def version(self):
        return '2.51.0'

    def build_requires(self):
        return ['libiconv', 'gettext', 'libffi', 'libpcre', 'zlib']

    def options(self):
        return self._options

    def download(self, env, target):
        shortversion = '2.51'
        url = 'http://ftp.gnome.org/pub/gnome/sources/%(package)s/%(shortversion)s/%(package)s-%(version)s.tar.xz' % {
            'package': self.name(), 'version': self.version(),
            'shortversion': shortversion,
        }
        steps.download(url, target)

    def prebuild(self, env, srcdir):
        steps.autoreconf(srcdir, env)

    def configure(self, env, srcdir):
        env['PCRE_CFLAGS'] = '-I/include'
        env['PCRE_LIBS'] = '-L/libraries -lpcre'
        steps.run_configure(self, srcdir, env, extra_config=(
            'glib_cv_stack_grows=no', 'glib_cv_uscore=no', 'ac_cv_func_posix_getpwuid_r=no',
            'ac_cv_func_posix_getgrgid_r=no', '--with-libiconv'))

    def build(self, env, srcdir):
        steps.make(srcdir, env)

    def deploy(self, env, srcdir, deploydir):
        env['DESTDIR'] = deploydir
        steps.make(srcdir, env, 'install')

    def links(self, env, deploydir, cross_dir):
        libs = ['gio', 'libgthread-2.0.so', 'libgmodule-2.0.so',
            'libgobject-2.0.so', 'glib-2.0', 'libglib-2.0.so', 'libgio-2.0.so']
        headers = ['glib-2.0', 'gio-unix-2.0']
        steps.symlinks(deploydir, cross_dir, libs=libs, headers=headers)
