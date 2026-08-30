# syntax = docker/dockerfile:1

FROM ruby:3.4.10-slim-trixie

# `seluser` - chrome container user & group. It's used to delete files from the downloads folder.
RUN groupadd --gid 1001 qa && \
    useradd --uid 1000 --gid 1001 --create-home --shell /bin/bash qa && \
    useradd --uid 1200 --gid 1001 --create-home --shell /bin/bash seluser && \
    mkdir /tests && chown qa:qa /tests

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends sudo && \
    echo "%qa ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        git curl build-essential libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tests

USER qa

CMD ["bash"]
