# alpine-python-matplotlib

This Dockerfile is a Proof of Concept, about using Python and Wheels on Alpine Linux.

First of all, a "Wheel" is a simple zip package of python files (.py or .pyc), and also often C libs(.so).
It's like a RPM ou DEB distribution OS package.

By default, Alpine support wheels with "-none-any.whl" extension. It's possible to install wheels with "-manylinux1_x86_64.whl" extension, by enabling with a simple flag in a file called `_manylinux.py` located in python path (see "os.path").

In our case, we create the file `/usr/lib/python3.8/site-packages/_manylinux.py` with the following content :

```
manylinux1_compatible = True
```

Why Alpine is not compatible by default with manylinux1 ? The answer is simple. Alpine is based on [Musl libc](http://musl.libc.org/) at the opposite of traditional Linux distro like Debian, with use massively the fat library "[glibc](https://www.gnu.org/software/libc/)". Most of wheel package are built with glibc distro. So embedded libraries are strongly linked with glibc. If you want execute them, you need to install [glibc](https://github.com/sgerrand/alpine-pkg-glibc) as an additional package in Alpine. Of course, it's not 100% fully compatible, but almost. Often unresolved symbols are simply missing libraries in the operating system, or misplaced files in expected directory.

Good advice, always to use the Alpine package (apk) of the python library you need. It's build with Musl compliance. You can found them by looking at [Alpine Package search](https://pkgs.alpinelinux.org/packages) website. Nota : Packages name are started by "py2-" or "py3-", by example for pandas in python 3 search "py3-pandas".
If you can't found them in the Alpine release repository, just add "edge" repositories into your "/etc/apk/repositories" file, and try again.

The frequent questions : 
- Why using apk and not Wheel ? Both are just package files with almost same files. Apks have compiled native libraries compliant with Musl.
- Can I build a wheel package of a python package with native libraries built on Musl libc ? The answer is "YES, you can". You need wheel and pip tools. When you install and build on Alpine from python source package, it will create a wheel package in default cache directory.

After, I build the docker image in few seconds and the size is less than 300Mo. I've tried "[seaborn](https://seaborn.pydata.org/examples/index.html)" and "[matplotlib](https://matplotlib.org/3.1.3/tutorials/introductory/sample_plots.html)" samples with success and without visible side effects.
