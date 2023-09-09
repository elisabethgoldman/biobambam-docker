FROM ubuntu:20.04

MAINTAINER Jeremiah H. Savage <jeremiahsavage@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV LD_LIBRARY_PATH /usr/local/lib

# Install dependencies
RUN apt-get update \
 && apt-get install -y \
    autoconf \
    curl \
    g++ \
    git \
    libtool \
    make \
    pkg-config \
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /usr/local/*

# Install libmaus2
RUN git clone https://gitlab.com/german.tischler/libmaus2.git --branch 2.0.610-release-20190328154814  \
 && cd libmaus2 \
 && libtoolize \
 && aclocal \
 && autoreconf -i -f \
 && ./configure \
 && make -j4 \
 && make install \
 && cd ../

# Install biobambam2
RUN git clone https://gitlab.com/german.tischler/biobambam2.git --branch 2.0.95-release-20190320141403 \
 && cd biobambam2 \
 && export LIBMAUSPREFIX=/usr/local \
 && autoreconf -i -f \
 && ./configure --with-libmaus2=${LIBMAUSPREFIX} \
 && make -j4 \
 && make install \
 && cd ../

# Clean dependencies
RUN apt-get remove --purge -y \
    autoconf \
    curl \
    g++ \
    git \
    libtool \
    make \
    pkg-config \
    zlib1g-dev \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp

