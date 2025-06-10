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
        ttaenc \
        tta \
        ffmpeg \
        coreutils \
        findutils \
        git \
        build-essential \
        wget \
        && rm -rf /var/lib/apt/lists/*

# Install mac (Monkey's Audio decoder) from source
RUN mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/fernandotcl/monkeys-audio.git && \
    cd monkeys-audio && \
    make && \
    cp mac /usr/local/bin/ && \
    chmod +x /usr/local/bin/mac && \
    cd / && rm -rf /opt/monkeys-audio

# Copy entrypoint and tagging script
COPY cuetag.sh /usr/local/bin/cuetag.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/local/bin/cuetag.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]