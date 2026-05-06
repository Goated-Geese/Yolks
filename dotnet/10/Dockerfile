# Pelican-compatible yolk: Ubuntu 24.04 (Noble) + Microsoft .NET 10 runtime.
#
# Provides a Pelican Wings runtime image with:
#  - .NET 10 runtime (glibc 2.39+ via Ubuntu 24.04 base)
#  - `container` user, /home/container HOME/WORKDIR, tini, entrypoint.sh
#
# Pelican custom yolk reference:
#   https://pelican.dev/docs/eggs/creating-a-custom-yolk
#
# Build (linux/amd64):
#   docker build -t ghcr.io/goated-geese/yolks:dotnet_10 .

FROM --platform=$TARGETOS/$TARGETARCH mcr.microsoft.com/dotnet/runtime:10.0-noble

LABEL org.opencontainers.image.authors="Goated Geese (GG-AU) <hello@gg-au.com>" \
      org.opencontainers.image.description="Pelican yolk - .NET 10 on Ubuntu 24 (glibc 2.39+)" \
      org.opencontainers.image.source="https://github.com/Goated-Geese/Yolks" \
      org.opencontainers.image.documentation="https://pelican.dev/docs/eggs/creating-a-custom-yolk" \
      org.opencontainers.image.licenses="MIT"

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        wget \
        git \
        iproute2 \
        jq \
        tar \
        tini \
        tzdata \
        libgdiplus \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -d /home/container -s /bin/bash container

COPY --chown=container:container entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER container
ENV USER=container HOME=/home/container DOTNET_ROOT=/usr/share
WORKDIR /home/container

STOPSIGNAL SIGINT

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
