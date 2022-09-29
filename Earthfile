VERSION 0.6

build-all-platforms:
    BUILD --platform=linux/amd64 --platform=linux/aarch64 +build-alpine

build-alpine:
  ARG TARGETPLATFORM
  FROM --platform=$TARGETPLATFORM docker.io/library/alpine:latest
  ENV DISABLE_NIX=true

  RUN apk add bash coreutils curl fish git gnupg less openssh-client python3 vim zsh
  RUN sed -i 's,root:x:0:0:root:/root:/bin/ash,root:x:0:0:root:/root:/usr/bin/fish,' /etc/passwd

  COPY . /root/.dotfiles
  WORKDIR /root/.dotfiles
  RUN ./install

  SAVE IMAGE dotfiles-test:latest
