# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:noble
LABEL author="Brett Kuskie <fullaxx@gmail.com>"

# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV QLIBCVERS="2.5.0"
ENV QLIBCURL="https://github.com/wolkykim/qlibc/archive/refs/tags/v${QLIBCVERS}.tar.gz"

# ------------------------------------------------------------------------------
# Prepare Python requirements.txt
COPY requirements.txt /install/requirements.txt

# ------------------------------------------------------------------------------
# Create a docker image suitable for development
# libpcap0.8-dbg is not available in jammy
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      calc \
      bash-completion \
      build-essential \
      ca-certificates \
      cgdb \
      cmake \
      curl \
      doxygen \
      dtach \
      file \
      gdb \
      git \
      hping3 \
      iproute2 \
      iputils-ping \
      jq \
      less \
      libcurl4-openssl-dev \
      libevent-dev \
      libgcrypt20-dev \
      libhiredis-dev \
      libmicrohttpd-dev \
      libnet1-dev libnet1-dbg \
      libpcap-dev \
      libsqlite3-dev \
      libssl-dev \
      libwebsockets-dev \
      libxml2-dev \
      libzmq3-dev \
      lbzip2 \
      lrzip \
      lsof \
      meson \
      nano \
      net-tools \
      openssh-client \
      pbzip2 \
      pigz \
      pixz \
      plzip \
      pv \
      python3-pip \
      rsync \
      run-one \
      screen \
      silversearcher-ag \
      sqlite3 \
      sshfs \
      supervisor \
      tcpdump \
      tmux \
      tree \
      tshark \
      unzip \
      vim-tiny \
      xxd \
      xxhash \
      zip \
      zlib1g-dev && \
    rm /usr/lib/python3*/EXTERNALLY-MANAGED && \
    pip3 install -r /install/requirements.txt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

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
