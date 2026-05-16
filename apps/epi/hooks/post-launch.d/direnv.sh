#!/usr/bin/env bash

"$EPI_BIN" exec "$EPI_INSTANCE" -- direnv allow "$PWD"
"$EPI_BIN" exec "$EPI_INSTANCE" -- systemd-run --user --unit=epi-project-direnv-pre-stage direnv exec "$PWD" true
