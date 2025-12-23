# syntax=docker/dockerfile:1
FROM docker.io/library/node:25-trixie-slim

ARG DEBIAN_FRONTEND="noninteractive"

RUN <<EOT
    set -o errexit && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
        bc \
        ca-certificates \
        curl \
        dnsutils \
        gh \
        git \
        jq \
        less \
        lsof \
        man-db \
        procps \
        psmisc \
        ripgrep \
        rsync \
        socat \
        unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
EOT

RUN npm install --global @google/gemini-cli

WORKDIR /workspace

RUN chown --recursive node:node /workspace

USER node

ENTRYPOINT [ "gemini" ]
