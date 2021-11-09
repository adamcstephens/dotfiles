#!/usr/bin/env bash

set -e

shopt -s expand_aliases
source ~/.dotfiles/shell_generic.sh

# test
sudo --non-interactive true

pkiyy curl git make python3 vim zsh

if [[ $1 == "dev" ]]; then
  pki --yes make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
fi
