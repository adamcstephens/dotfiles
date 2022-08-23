#!/usr/bin/env sh

if [ ! -e ~/.ssh/id_ed25519 ]; then
  echo "Missing key ~/.ssh/id_ed25519"
  exit 1
fi

echo "key::$(cat ~/.ssh/id_ed25519.pub)"
