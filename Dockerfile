FROM hypriot/rpi-alpine-scratch:v3.4

RUN adduser -D -S -h /home/gitlab-runner gitlab-runner

RUN apk add --no-cache \
    dumb-init=1.2.0-r0 \
    bash \
    ca-certificates \
    git \
    openssl \
    wget

ADD https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-arm /usr/bin/gitlab-ci-multi-runner

RUN chmod +x /usr/bin/gitlab-ci-multi-runner && \
    ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && \
    wget -q https://github.com/docker/machine/releases/download/v0.10.0/docker-machine-Linux-aarch64 -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner

COPY entrypoint /
RUN chmod +x /entrypoint

VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
