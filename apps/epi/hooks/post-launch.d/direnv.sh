#!/usr/bin/env bash

if "$EPI_BIN" exec "$EPI_INSTANCE" -- command -q direnv; then
  "$EPI_BIN" exec "$EPI_INSTANCE" -- direnv allow "$EPI_PROJECT_DIR"
  "$EPI_BIN" exec "$EPI_INSTANCE" -- systemd-run --user --unit=epi-project-direnv-pre-stage direnv exec "$EPI_PROJECT_DIR" true
fi
