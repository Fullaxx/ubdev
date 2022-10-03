# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:focal
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV QLIBCVERS "2.4.6"

# ------------------------------------------------------------------------------
# Create a docker image suitable for development
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      doxygen \
      git \
      libcurl4-gnutls-dev \
      libevent-dev \
      libgcrypt-dev \
      libhiredis-dev \
      libmicrohttpd-dev \
      libnet1-dev \
      libpcap-dev \
      libsqlite3-dev \
      libssl-dev \
      libwebsockets-dev \
      libxml2-dev \
      libzmq3-dev \
      nano \
      unzip \
      vim-tiny \
      xxhash \
      zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Install qlibc 2.4.6
RUN cd /tmp && \
    curl -L https://github.com/wolkykim/qlibc/archive/refs/tags/v${QLIBCVERS}.tar.gz -o qlibc-${QLIBCVERS}.tar.gz && \
    tar xf qlibc-${QLIBCVERS}.tar.gz && cd qlibc-${QLIBCVERS} && \
    ./configure --prefix=/usr --docdir=/usr/share/doc/qlibc-${QLIBCVERS} --libdir=/usr/lib64 && \
    make && make install && cd src && doxygen doxygen.conf && \
    mkdir /usr/share/doc/qlibc-${QLIBCVERS} && cd /tmp && \
    cp -r qlibc-${QLIBCVERS}/doc/html /usr/share/doc/qlibc-${QLIBCVERS}/ && \
    rm -rf qlibc-${QLIBCVERS}

# ------------------------------------------------------------------------------
# Define default entrypoint
CMD ["/bin/bash"]
