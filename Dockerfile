FROM alpine:latest

## Install from python 3 and glibc
## Also add Alpine package of numpy, kiwisolver, scipy and pandas 
RUN echo -e "http://dl-cdn.alpinelinux.org/alpine/edge/main\nhttp://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk -U --no-cache add python3 wget ca-certificates py3-numpy py3-kiwisolver py3-scipy py3-pandas &&  \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-bin-2.30-r0.apk && \
    apk --no-cache add glibc-2.30-r0.apk && \
    rm -f /usr/glibc-compat/lib/ld-linux-x86-64.so.2 && ln -s /usr/glibc-compat/lib/ld-2.30.so /usr/glibc-compat/lib/ld-linux-x86-64.so.2 && \
    apk --no-cache add glibc-bin-2.30-r0.apk && \ 
    rm -rf glibc*.apk /var/cache/apk/* && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    python3 -m ensurepip && \
    rm -rf /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi
    
## Enable manylinux1 wheels
RUN echo "manylinux1_compatible = True" > /usr/lib/python3.8/site-packages/_manylinux.py

## Install matplotlib and seaborn
RUN pip install --no-cache-dir matplotlib seaborn
