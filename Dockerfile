# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:focal
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# ------------------------------------------------------------------------------
# Create a docker image suitable for development
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential git \
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
# Define default entrypoint
CMD ["/bin/bash"]
