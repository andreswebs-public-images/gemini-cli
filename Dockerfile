# syntax=docker/dockerfile:1
FROM docker.io/library/node:24-trixie-slim

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

WORKDIR /workspace

RUN chown --recursive node:node /workspace

USER node

RUN npm install --global @google/gemini-cli
RUN npx @google-cloud/gcloud-mcp init --agent=gemini-cli

ENTRYPOINT [ "gemini" ]
