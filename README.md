shadowsocks-obfs-docker
=================

[shadowsocks-libev][1] is a lightweight secured socks5 proxy for embedded
devices and low end boxes.  It is a port of [shadowsocks][2] created by
@clowwindy maintained by @madeye and @linusyang.

Suppose we have a VPS running Debian or Ubuntu.
To deploy the service quickly, we can use [docker][3].

## Install docker

```
$ curl -sSL https://get.docker.com/ | sh
$ docker --version
```

## Build docker image

```bash
$ curl -sSL https://github.com/allen0125/shadowsocks-obfs-docker/blob/master/Dockerfile | docker build -t shadowsocks
$ docker images
```


## Run docker container

```bash
$ docker run -d -e METHOD=aes-256-cfb -e PASSWORD=9MLSpPmNt -p 8388:8388 --restart always shadowsocks
$ docker ps
```

> :warning: Click [here][6] to generate a strong password to protect your server.
> You can use `ARGS` environment variable to pass additional arguments


[1]: https://github.com/shadowsocks/shadowsocks-libev
[2]: https://shadowsocks.org/en/index.html
[3]: https://github.com/docker/docker
[4]: https://hub.docker.com/r/vimagick/shadowsocks-libev/
[5]: https://badge.imagelayers.io/vimagick/shadowsocks-libev:latest.svg
[6]: https://duckduckgo.com/?q=password+12&t=ffsb&ia=answer
[7]: https://github.com/docker/compose
[8]: https://shadowsocks.org/en/download/clients.html
