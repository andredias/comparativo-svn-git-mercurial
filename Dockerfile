FROM ubuntu:latest

MAINTAINER André Felipe Dias <andre.dias@pronus.io>

RUN apt-get update && \
    apt-get install -y software-properties-common

RUN add-apt-repository -y ppa:dominik-stadler/subversion-1.9 && \
    add-apt-repository -y ppa:git-core/ppa && \
    apt-add-repository -y ppa:mercurial-ppa/releases && \
    apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    subversion git mercurial \
    man-db \
    make build-essential

WORKDIR /tmp

# instalação e configuração do chg
RUN hg clone https://selenic.com/repo/hg && \
    cd hg/contrib/chg && \
    make && make install && \
    alias hg=chg && \
    cd /tmp && \
    rm -rf hg

ADD desempenho.* /usr/local/bin/
