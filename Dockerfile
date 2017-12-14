#
# Dockerfile for shadowsocks-libev
#

FROM alpine
MAINTAINER kev <noreply@datageek.info>

ARG SS_VER=3.1.1
ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz

ARG OBFS_VER=0.0.5
ARG OBFS_URL=https://github.com/shadowsocks/simple-obfs/archive/v$OBFS_VER.tar.gz
ARG OBFS_DIR=simple-obfs-$OBFS_VER

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD=
ENV METHOD      aes-256-cfb
ENV TIMEOUT     300
ENV DNS_ADDR    8.8.8.8
ENV DNS_ADDR_2  8.8.4.4
ENV ARGS=

RUN set -ex && \
    apk add --no-cache --virtual .build-deps \
                                autoconf \
                                build-base \
                                curl \
                                libev-dev \
                                linux-headers \
                                libsodium-dev \
                                mbedtls-dev \
                                pcre-dev \
                                git \
                                tar \
                                c-ares-dev \
    && apk add --no-cache \
               --virtual TMP autoconf make libtool automake \
                             openssl asciidoc xmlto \
                             libpcre32 libev-dev g++ linux-headers && \
    cd /tmp && \
    curl -sSL $SS_URL | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd .. && \
    git clone https://github.com/shadowsocks/simple-obfs.git && \
    cd simple-obfs && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure && make && \
    make install && \
    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    rm -rf /tmp/* \
    && apk del TMP
USER nobody
EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp
CMD ss-server -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -k ${PASSWORD:-$(hostname)} \
              -m $METHOD \
              -t $TIMEOUT \
              --fast-open \
              -d $DNS_ADDR \
              -d $DNS_ADDR_2 \
              --plugin obfs-server --plugin-opts "obfs=http" \
              -u \
              $ARGS
