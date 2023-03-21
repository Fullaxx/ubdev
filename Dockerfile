# ------------------------------------------------------------------------------
# Build python xxhash module
FROM ubuntu:jammy AS pybuild
ENV XXHASHURL https://files.pythonhosted.org/packages/24/90/666a4d4d96a93ddaaaa0142ef8c1bd20f7135a7f1114a894f4d6efac16c5/xxhash-3.2.0.tar.gz
RUN apt-get update && \
	apt-get install -y build-essential python3-dev python3-setuptools wget && \
	wget ${XXHASHURL} && \
	tar xvf xxhash-*.tar.gz && \
	cd xxhash-* && \
	python3 setup.py install

# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:jammy
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV QLIBCVERS "2.4.8"
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
      nano \
      pbzip2 \
      pigz \
      pixz \
      plzip \
      pv \
      silversearcher-ag \
      sqlite3 \
      supervisor \
      unzip \
      vim-tiny \
      xxhash \
      zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Install python xxhash module from build container
COPY --from=pybuild /usr/local/lib/python3.10 /usr/local/lib/python3.10

# ------------------------------------------------------------------------------
# Install qlibc
RUN cd /tmp && \
    curl -L ${QLIBCURL} -o qlibc-${QLIBCVERS}.tar.gz && \
    tar xf qlibc-${QLIBCVERS}.tar.gz && cd qlibc-${QLIBCVERS} && \
    ./configure --prefix=/usr --libdir=/usr/lib64 && make && make install && \
    cd src && doxygen doxygen.conf && mkdir /usr/share/doc/qlibc-${QLIBCVERS} && \
    cd /tmp && cp -r qlibc-${QLIBCVERS}/doc/html /usr/share/doc/qlibc-${QLIBCVERS}/ && \
    rm -rf qlibc-${QLIBCVERS} qlibc-${QLIBCVERS}.tar.gz

# ------------------------------------------------------------------------------
# Define default command
CMD ["/bin/bash"]
