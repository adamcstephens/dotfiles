#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "usage: $0 <target host>"
  exit 1
fi

TARGET="$1"

ssh "$TARGET" mkdir -p ~/.config/omp/agent
if ssh "$TARGET" test -e ~/.config/omp/agent/agent.db; then
  echo ":: Removing old credentials"
  ssh "$TARGET" 'sqlite3 ~/.config/omp/agent/agent.db "DROP TABLE IF EXISTS auth_credentials"'
fi
echo ":: Pushing credentials"
sqlite3 "$HOME/.config/omp/agent/agent.db" '.dump auth_credentials' | ssh "$TARGET" 'sqlite3 ~/.config/omp/agent/agent.db'
echo ":: Done"
