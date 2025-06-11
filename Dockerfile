FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash ca-certificates flac cuetools shntool wavpack ffmpeg cmake \
        coreutils findutils git build-essential wget unzip \
    && rm -rf /var/lib/apt/lists/*

# Build Monkey's Audio (mac) with CMake
RUN git clone https://github.com/fernandotcl/monkeys-audio.git /opt/monkeys-audio && \
    mkdir -p /opt/monkeys-audio/build && \
    cd /opt/monkeys-audio/build && \
    cmake .. && make && \
    cp mac /usr/local/bin/ && chmod +x /usr/local/bin/mac && \
    rm -rf /opt/monkeys-audio

# Fetch and install prebuilt ttaenc
RUN wget https://downloads.sourceforge.net/project/tta/tta/ttaenc-linux/ttaenc-3.4.1.tgz && \
    tar -xzf ttaenc-3.4.1.tgz && \
    cp ttaenc-3.4.1-bin/ttaenc /usr/local/bin/ && chmod +x /usr/local/bin/ttaenc && \
    rm ttaenc-3.4.1.tgz

# Copy and set up splitter/tagger scripts
COPY cuetag.sh /usr/local/bin/cuetag.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /usr/local/bin/cuetag.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
