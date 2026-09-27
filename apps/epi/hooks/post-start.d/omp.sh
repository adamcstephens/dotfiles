#!/usr/bin/env bash

if "$EPI_BIN" exec "$EPI_INSTANCE" -- command -q omp; then
  "$EPI_BIN" exec "$EPI_INSTANCE" -- mkdir -p ~/.config/omp/agent
  if "$EPI_BIN" exec "$EPI_INSTANCE" -- test -e ~/.config/omp/agent/agent.db; then
    "$EPI_BIN" exec "$EPI_INSTANCE" -- 'sqlite3 ~/.config/omp/agent/agent.db "DROP TABLE IF EXISTS auth_credentials"'
  fi
  sqlite3 "$HOME/.config/omp/agent/agent.db" '.dump auth_credentials' | "$EPI_BIN" exec "$EPI_INSTANCE" -- 'sqlite3 ~/.config/omp/agent/agent.db'
fi
