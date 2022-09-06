#!/usr/bin/env sh

if [ -e ~/.ssh/id_ed25519 ]; then
  key="$(cat ~/.ssh/id_ed25519.pub)"
elif [ -n "$SSH_AUTH_SOCK" ]; then
  key="$(ssh-add -L | head -n 1)"
fi

if [ -z "$key" ]; then
  echo "Failed to detect key. ibailout"
  exit 1
fi

echo "key::$key"
