FROM ubuntu:latest AS builder
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xz-utils \
    git \
    build-essential \
    python3 \
    python3-venv \
    zip \
    bash \
    busybox && \
    rm -rf /var/lib/apt/lists/*

COPY fetch_tools ./fetch_tools

RUN chmod +x ./fetch_tools/fetch_tools.sh && cd fetch_tools && ./fetch_tools.sh

WORKDIR /app

COPY dotfiles ./dotfiles
RUN cp -r ./dotfiles/. /root && cp -r ./fetch_tools/target/. /root

ENV PATH="/root/.local/bin:${PATH}"

RUN bash -l -c erd --completions bash > /root/.local/share/bash-completion/completions/erd
RUN bash -l -c "nvim --headless -c MasonUpdate -c 'MasonInstall lua-language-server' -c 'TSInstallSync bash python' -c q"
RUN bash -l -c "nvim --headless -c 'MasonInstall shellcheck' -c q"

# fix for absolute path in lua language server
RUN sed -i 's/\/root\/.local/~\/.local/g' /root/.local/share/nvim/mason/packages/lua-language-server/lua-language-server

COPY fetch_licenses.sh ./fetch_licenses.sh
RUN bash fetch_licenses.sh && \
    zip -r server_homedir_THIRD_PARTY_LICENSES.zip licenses && \
    rm -rf licenses && mv server_homedir_THIRD_PARTY_LICENSES.zip /root

RUN rm -r /root/.wget-hsts /root/.cache /root/.bashrc


FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

# Install only the necessary RUNTIME dependencies.
RUN apt-get update && apt-get install -y python3 git bash zip
    #rm -rf /var/lib/apt/lists/*

USER ubuntu
RUN find /home/ubuntu/ -mindepth 1 -delete
COPY --from=builder --chown=ubuntu:ubuntu /root /home/ubuntu/
COPY --chown=ubuntu:ubuntu README.md /home/ubuntu/
WORKDIR /home/ubuntu/
RUN mv README.md server_homedir_README.md
RUN zip -9yr /tmp/server_homedir.zip . && mv /tmp/server_homedir.zip .

WORKDIR /app

#ENV PATH="/root/.local/bin:${PATH}"
ENV HOME="/home/ubuntu"

CMD ["bash", "-l"]