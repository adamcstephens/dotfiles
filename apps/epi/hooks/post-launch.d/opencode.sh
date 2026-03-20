#!/usr/bin/env bash

"$EPI_BIN" exec "$EPI_INSTANCE" -- "mkdir -vp ~/.config/opencode"
"$EPI_BIN" cp ~/.config/opencode/opencode.json "$EPI_INSTANCE:.config/opencode/"
