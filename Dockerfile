FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        flac \
        cuetools \
        shntool \
        vorbis-tools \
        coreutils \
        findutils \
        git \
        build-essential \
        wget \
        ffmpeg \
        && rm -rf /var/lib/apt/lists/*

# Install mac (Monkey's Audio) from source
RUN mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/danielpoe/monkeys-audio.git && \
    cd monkeys-audio && \
    make && \
    cp mac /usr/local/bin/ && \
    chmod +x /usr/local/bin/mac

# Install WavPack (WV) and TTA
RUN apt-get update && \
    apt-get install -y wavpack tta && \
    rm -rf /var/lib/apt/lists/*

# Ensure shnsplit is installed
RUN apt-get update && \
    apt-get install -y shnsplit && \
    rm -rf /var/lib/apt/lists/*

COPY cuetag.sh /usr/local/bin/cuetag.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/local/bin/cuetag.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]