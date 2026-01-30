# syntax=docker/dockerfile:1
FROM docker.io/library/node:24-trixie

ARG DEBIAN_FRONTEND="noninteractive"
ARG DEBCONF_NONINTERACTIVE_SEEN="true"

COPY --from=mikefarah/yq /usr/bin/yq /usr/local/bin/
COPY --from=denoland/deno:bin-2.6.4 /deno /usr/local/bin/
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/
COPY --from=oven/bun:1 /usr/local/bin/bun /usr/local/bin/bunx /usr/local/bin/

RUN <<EOT
    set -o errexit
    apt-get update
    apt-get install --yes --no-install-recommends \
        bc \
        bzip2 \
        ca-certificates \
        curl \
        dnsutils \
        gh \
        git \
        jq \
        less \
        lsof \
        man-db \
        netcat-openbsd \
        openssh-client \
        procps \
        psmisc \
        ripgrep \
        rsync \
        socat \
        sudo \
        tree \
        unzip \
        vim \
        zip
    apt-get clean
    rm -rf /var/lib/apt/lists/*
EOT

WORKDIR /workspace
RUN chown --recursive node:node /workspace

USER node

ENV HOME="/home/node"
ENV NPM_CONFIG_PREFIX="${HOME}/.npm-global"
ENV PATH="${HOME}/.local/bin:${HOME}/.npm-global/bin:${HOME}/.bun/bin:${PATH}"
ENV EDITOR="vim"

RUN mkdir --parents "${HOME}/.local/share"
RUN mkdir --parents "${HOME}/.local/bin"
RUN echo 'export PS1="\e[34m\u@\h\e[35m \w\e[0m\n$ "' >> "${HOME}/.bashrc"

RUN npm install --global @dbml/cli
RUN npm install --global @sourcemeta/jsonschema

RUN <<EOT
    set -o errexit -o pipefail
    git clone https://github.com/wedow/ticket.git "${HOME}/.local/share/ticket"
    cd "${HOME}/.local/share/ticket" || exit 1
    ln --symbolic "$(pwd)/ticket" "${HOME}/.local/bin/tk"
EOT

RUN <<EOT
    {
        echo ":set number"
        echo ":set et"
        echo ":set sw=2 ts=2 sts=2"
    } > "${HOME}/.vimrc"
EOT

RUN npm install --global @google/gemini-cli

ENTRYPOINT [ "gemini" ]
