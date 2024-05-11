# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:jammy
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV QLIBCVERS "2.5.0"
ENV QLIBCURL "https://github.com/wolkykim/qlibc/archive/refs/tags/v${QLIBCVERS}.tar.gz"

# ------------------------------------------------------------------------------
# Create a docker image suitable for development
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      doxygen \
      git \
      hping3 \
      iproute2 \
      iputils-ping \
      jq \
      less \
      libcurl4-openssl-dev \
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
      lbzip2 \
      lrzip \
      lsof \
      nano \
      net-tools \
      pbzip2 \
      pigz \
      pixz \
      plzip \
      pv \
      rsync \
      run-one \
      silversearcher-ag \
      sqlite3 \
      supervisor \
      unzip \
      vim-tiny \
      xxhash \
      zip \
      zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Install python modules and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-pip && \
    python3 -m pip install ipython redis[hiredis] pandas==2.1.4 pyzmq xxhash && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Install qlibc
RUN cd /tmp && \
    curl -L ${QLIBCURL} -o qlibc-${QLIBCVERS}.tar.gz && \
    tar xf qlibc-${QLIBCVERS}.tar.gz && cd qlibc-${QLIBCVERS} && \
    ./configure --prefix=/usr --libdir=/usr/lib64 && make && make install && \
    cd src && doxygen doxygen.conf && mkdir /usr/share/doc/qlibc-${QLIBCVERS} && \
    cd /tmp && cp -r qlibc-${QLIBCVERS}/doc/html /usr/share/doc/qlibc-${QLIBCVERS}/ && \
    rm -rf qlibc-${QLIBCVERS} qlibc-${QLIBCVERS}.tar.gz && \
    ldconfig

# ------------------------------------------------------------------------------
# Define default command
CMD ["/bin/bash"]
