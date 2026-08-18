FROM python:3.12-slim

ARG DEBIAN_FRONTEND=noninteractive

# Runtime/build dependencies:
# - ffmpeg: audio encoding + DDS conversion
# - libvorbis: Vorbis encoding support
# - git/curl/unzip: obtain vgmstream
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        libvorbis0a \
        libvorbisenc2 \
        git \
        ca-certificates \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install psarc2feedpak directly from the upstream repository.
RUN pip install --no-cache-dir \
        construct \
        cryptography \
        "git+https://github.com/carelesshangman/psarc2feedpak.git"

# Download a Linux vgmstream-cli build.
# The psarc2feedpak project requires vgmstream-cli for Wwise .wem decoding.
RUN mkdir -p /opt/vgmstream && \
    curl -fsSL \
      https://github.com/vgmstream/vgmstream/releases/latest/download/vgmstream-linux.zip \
      -o /tmp/vgmstream.zip && \
    unzip -q /tmp/vgmstream.zip -d /opt/vgmstream && \
    find /opt/vgmstream -type f -name vgmstream-cli -exec cp {} /usr/local/bin/vgmstream-cli \; && \
    chmod +x /usr/local/bin/vgmstream-cli && \
    rm -rf /tmp/vgmstream.zip /opt/vgmstream

COPY entrypoint.sh /usr/local/bin/psarc2feedpak-docker
RUN chmod +x /usr/local/bin/psarc2feedpak-docker

ENTRYPOINT ["psarc2feedpak-docker"]
