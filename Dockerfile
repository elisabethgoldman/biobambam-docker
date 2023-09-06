FROM ubuntu:20.04

MAINTAINER Jeremiah H. Savage <jeremiahsavage@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV LD_LIBRARY_PATH /usr/local/lib

RUN apt-get update \
    && apt-get install -y \
        autoconf \
        curl \
        g++ \
        libtool \
        pkg-config \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /usr/local/* \
    && curl --silent https://gitlab.com/german.tischler/libmaus2/repository/archive.tar.gz\?ref\=2.0.610-release-20190328154814 -o libmaus2.tar.gz \
    && curl --silent https://gitlab.com/german.tischler/biobambam2/repository/archive.tar.gz\?ref\=2.0.95-release-20190320141403 -o biobambam2.tar.gz \
    && libmaus2files=$(tar -axvf libmaus2.tar.gz) \
    && libmaus2dir=$(echo ${libmaus2files} | cut -f1 -d" ") \
    && cd ${libmaus2dir} \
    && libtoolize \
    && aclocal \
    && autoreconf -i -f \
    && ./configure \
    && make -j4 \
    && make install \
    && cd ../ \
    && rm -rf ${libmaus2dir} libmaus2.tar.gz \
    && biobambam2files=$(tar -axvf biobambam2.tar.gz) \
    && biobambam2dir=$(echo ${biobambam2files} | cut -f1 -d" ") \
    && cd ${biobambam2dir} \
    && export LIBMAUSPREFIX=/usr/local \
    && autoreconf -i -f \
    && ./configure --with-libmaus2=${LIBMAUSPREFIX} \
    && make -j4 \
    && make install \
    && cd ../ \
    && rm -rf ${biobambam2dir} biobambam2.tar.gz \
    && apt-get remove --purge -y \
        autoconf \
        curl \
        g++ \
        libtool \
        pkg-config \
        zlib1g-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
