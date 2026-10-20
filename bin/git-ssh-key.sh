#!/usr/bin/env sh

if [ -S "$SSH_AUTH_SOCK" ]; then
  key="$(ssh-add -L | head -n 1)"
fi

if [ -z "$key" ]; then
  echo "Failed to detect key. ibailout"
  exit 1
fi

echo "key::$key"
