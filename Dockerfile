
FROM ubuntu:latest AS builder
ENV DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH=amd64

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

ENV ARCH=${TARGETARCH}
COPY fetch_tools ./fetch_tools

RUN chmod +x ./fetch_tools/fetch_tools.sh && cd fetch_tools && ./fetch_tools.sh
RUN bash ./fetch_tools/fetch_licenses.sh && \
  zip -r server_homedir_THIRD_PARTY_LICENSES.zip licenses &&\
  mv server_homedir_THIRD_PARTY_LICENSES.zip /root

WORKDIR /app

COPY dotfiles ./dotfiles
RUN cp -r ./dotfiles/. /root && cp -r ./fetch_tools/target/. /root

FROM --platform=${TARGETARCH} ubuntu:latest AS setup
ENV DEBIAN_FRONTEND=noninteractive

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

ENV PATH="/root/.local/bin:${PATH}"
COPY --from=builder /root /root

COPY setup.sh ./setup.sh
RUN bash ./setup.sh


FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

# Install only the necessary RUNTIME dependencies.
RUN apt-get update && apt-get install -y python3 python3-venv git bash zip
    #rm -rf /var/lib/apt/lists/*

USER ubuntu
RUN find /home/ubuntu/ -mindepth 1 -delete
COPY --from=setup --chown=ubuntu:ubuntu /root /home/ubuntu/
COPY --chown=ubuntu:ubuntu README.md /home/ubuntu/
WORKDIR /home/ubuntu/
RUN rm .profile
RUN mv README.md server_homedir_README.md
RUN zip -9yr /tmp/server_homedir.zip . && mv /tmp/server_homedir.zip .

WORKDIR /app

#ENV PATH="/root/.local/bin:${PATH}"
ENV HOME="/home/ubuntu"

CMD ["bash", "-l"]