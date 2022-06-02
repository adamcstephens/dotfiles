VERSION 0.6
FROM docker.io/library/alpine:latest
WORKDIR /root/.dotfiles

build:
  RUN apk add bash coreutils curl fish git gnupg less openssh-client python3 vim zsh
  RUN sed -i 's,root:x:0:0:root:/root:/bin/ash,root:x:0:0:root:/root:/usr/bin/fish,' /etc/passwd

  COPY . /root/.dotfiles
  RUN ./install

  SAVE IMAGE dotfiles-test:latest
