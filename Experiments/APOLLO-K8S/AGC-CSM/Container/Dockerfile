# Apollo Guidance Computer - Command/Service Module (Colossus249)
# -----------------------------------------
# Stage 1: Build yaAGC + Colossus249
# -----------------------------------------
FROM ubuntu:24.04 AS build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git \
      make \
      gcc \
      g++ \
      libncurses-dev \
      ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /agc

# Clone VirtualAGC
RUN git clone https://github.com/virtualagc/virtualagc.git .

# Build the AGC emulator + Apollo 11 CSM program
# Colossus249 is the Apollo 11 Command Module software
RUN make -j"$(nproc)" yaAGC Colossus249

# -----------------------------------------
# Stage 2: Runtime image
# -----------------------------------------
FROM ubuntu:24.04 AS runtime

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libncurses6 \
      ca-certificates \
      netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /agc

# Copy the emulator + CSM core rope
COPY --from=build /agc/yaAGC/yaAGC ./yaAGC
COPY --from=build /agc/Colossus249/Colossus249.bin ./Colossus249.bin

# Copy entrypoint
COPY entrypoint.sh /agc/entrypoint.sh
RUN chmod +x /agc/entrypoint.sh

EXPOSE 1969

ENTRYPOINT ["/agc/entrypoint.sh"]
