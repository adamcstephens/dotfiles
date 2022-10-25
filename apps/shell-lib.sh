#!/usr/bin/env sh

. "$HOME"/.dotfiles/.envrc

check_registry() {
  if [ -z "$DOCKER_REGISTRY" ]; then
    echo "Must configure DOCKER_REGISTRY env variables"
    exit 1
  fi
}
