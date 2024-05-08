#!/usr/bin/env sh

SSH_AUTH_SOCK="$(~/.dotfiles/bin/ssh-agent-mgr)"

if [ -n "$SSH_AUTH_SOCK" ]; then
  key="$(ssh-add -L | head -n 1)"
fi

if [ -z "$key" ]; then
  echo "Failed to detect key. ibailout"
  exit 1
fi

echo "key::$key"
