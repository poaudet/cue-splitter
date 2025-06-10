FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base packages and audio tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        bash \
        flac \
        cuetools \
        shntool \
        wavpack \
        ffmpeg \
        coreutils \
        findutils \
        git \
        build-essential \
        wget \
        && rm -rf /var/lib/apt/lists/*

# Install Monkey's Audio (mac) from source
RUN mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/fernandotcl/monkeys-audio.git && \
    cd monkeys-audio && \
    make && \
    cp mac /usr/local/bin/ && \
    chmod +x /usr/local/bin/mac && \
    cd / && rm -rf /opt/monkeys-audio

# Install TTA (True Audio) from source
RUN mkdir -p /opt && \
    cd /opt && \
    wget https://github.com/tta-dev/tta/archive/refs/tags/v0.5.4.tar.gz && \
    tar -xzvf v0.5.4.tar.gz && \
    cd tta-0.5.4 && \
    make && \
    cp ttaenc /usr/local/bin/ && \
    chmod +x /usr/local/bin/ttaenc && \
    cd / && rm -rf /opt/tta-0.5.4

# Copy cuetag.sh and entrypoint.sh
COPY cuetag.sh /usr/local/bin/cuetag.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/local/bin/cuetag.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]