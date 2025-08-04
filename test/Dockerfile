FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    unzip \
    git-core \
    sudo \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash tester

USER tester
WORKDIR /home/tester

COPY --chown=tester:tester requirements.txt .
RUN python3 -m pip install --user -r requirements.txt
ENV PATH="/home/tester/.local/bin:${PATH}"