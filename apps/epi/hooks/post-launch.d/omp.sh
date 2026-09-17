#!/usr/bin/env bash

if "$EPI_BIN" exec "$EPI_INSTANCE" -- command -q omp && ! "$EPI_BIN" exec "$EPI_INSTANCE" -- test -e ~/.config/omp/agent/agent.db; then
  "$EPI_BIN" exec "$EPI_INSTANCE" -- mkdir -p ~/.config/omp/agent
  nix run "nixpkgs#sqlite" -- "$HOME/.config/omp/agent/agent.db" '.dump auth_credentials' | "$EPI_BIN" exec "$EPI_INSTANCE" -- 'nix run "nixpkgs#sqlite" -- ~/.config/omp/agent/agent.db'
fi
