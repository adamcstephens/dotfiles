#!/usr/bin/env bash

"$EPI_BIN" exec "$EPI_INSTANCE" -- mkdir -vp .config/tea
"$EPI_BIN" cp ~/.config/tea/config.yml "$EPI_INSTANCE:.config/tea/config.yml" || true
