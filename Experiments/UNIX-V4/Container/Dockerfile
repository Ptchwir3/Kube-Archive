FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# ----------------------------
# Build + runtime deps
# ----------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    ca-certificates \
    curl \
    libreadline-dev \
    libncurses-dev \
    libedit-dev \
    libbsd-dev \
    libpcre2-dev \
    libpcap-dev \
    libsdl2-dev \
    libpng-dev \
    libvdeplug-dev \
  && rm -rf /var/lib/apt/lists/*

# ----------------------------
# Build SIMH (PDP-11)
# ----------------------------
WORKDIR /opt
RUN git clone https://github.com/simh/simh.git \
  && cd simh \
  && make pdp11 \
  && cp BIN/pdp11 /usr/local/bin/pdp11

# ----------------------------
# Runtime dirs
# ----------------------------
RUN mkdir -p /simh /data

# ----------------------------
# Copy configuration + entrypoint
# ----------------------------
COPY unixv5.ini /simh/unixv
