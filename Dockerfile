FROM ubuntu:latest

MAINTAINER André Felipe Dias <andre.dias@pronus.io>

# http://askubuntu.com/questions/581458/how-to-configure-locales-to-unicode-in-a-docker-ubuntu-14-04-container
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

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

# habilitação de algumas extensões
RUN echo '[extensions]\n\
strip =\n\
histedit =\n\
rebase =\n' > /etc/mercurial/hgrc.d/extensoes.rc

ADD *.sh /usr/local/bin/
ADD *.py /usr/local/bin/
