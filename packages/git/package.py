
import os

from support import buildsystem
from support import steps


class GitPackage(buildsystem.Package):

    def __init__(self, *args, **kwargs):
        super(GitPackage, self).__init__(*args, **kwargs)
        self._options = buildsystem.Options()
        self.tarfile_format = 'gz'

    def name(self):
        return 'git'

    def version(self):
        return '2.8.2'

    def build_requires(self):
        return ['zlib', 'libiconv', 'curl', 'openssl']

    def patches(self, env, srcdir):
        return []

    def options(self):
        return self._options

    def download(self, env, target):
        url = 'https://www.kernel.org/pub/software/scm/%(package)s/%(package)s-%(version)s.tar.gz' % {
            'package': self.name(),
            'version': self.version(),
        }
        steps.download(url, target)

    def prebuild(self, env, srcdir):
        pass

    def configure(self, env, srcdir):
        steps.run_configure(self, srcdir, env, extra_config=(
            'ac_cv_fread_reads_directories=no', 'ac_cv_func_clock_gettime=no',
            'ac_cv_snprintf_returns_bogus=no', '--without-tcltk',
            '--with-lib=libraries', '--with-openssl', '--with-curl',))

    def build(self, env, srcdir):
        steps.make(srcdir, env)

    def deploy(self, env, srcdir, deploydir):
        env['DESTDIR'] = deploydir
        steps.make(srcdir, env, target='install')
