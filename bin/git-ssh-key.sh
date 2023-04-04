#!/usr/bin/env sh

if [ -n "$SSH_AUTH_SOCK" ]; then
  key="$(ssh-add -L | head -n 1)"
elif [ -e ~/.ssh/id_ed25519 ]; then
  key="$(cat ~/.ssh/id_ed25519.pub)"
fi

if [ -z "$key" ]; then
  echo "Failed to detect key. ibailout"
  exit 1
fi

echo "key::$key"
