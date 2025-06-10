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
        && rm -rf /var/lib/apt/lists/*

COPY cuetag.sh /usr/local/bin/cuetag.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/local/bin/cuetag.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
