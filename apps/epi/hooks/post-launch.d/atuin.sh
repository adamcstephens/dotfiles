#!/usr/bin/env bash

"$EPI_BIN" exec "$EPI_INSTANCE" -- mkdir -vp .local/share/atuin
"$EPI_BIN" cp ~/.local/share/atuin/key "$EPI_INSTANCE:.local/share/atuin/key"
"$EPI_BIN" cp ~/.local/share/atuin/session "$EPI_INSTANCE:.local/share/atuin/session"
