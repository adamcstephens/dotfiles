#!/usr/bin/env bash

set -e

[ -f /etc/os-release ] && source /etc/os-release

if [ "$NAME" == "Ubuntu" ]; then
  sudo apt-get install --yes /
  build-essential /
  curl /
  libbz2-dev /
  libffi-dev /
  liblzma-dev /
  libncursesw5-dev /
  libreadline-dev /
  libsqlite3-dev /
  libssl-dev /
  libxml2-dev /
  libxmlsec1-dev /
  llvm /
  make /
  tk-dev /
  wget /
  xz-utils /
  zlib1g-dev
fi
