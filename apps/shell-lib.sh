#!/usr/bin/env sh

cd "$HOME"/.dotfiles
eval "$(direnv export bash)"

check_registry() {
  if [ -z "$DOCKER_REGISTRY" ]; then
    echo "Must configure DOCKER_REGISTRY env variables"
    exit 1
  fi
}
