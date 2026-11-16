#!/usr/bin/env bash

TOKEN="$HOME/.local/state/onenix/current/forgejo-token"

if [ -e "$TOKEN" ]; then
  "$EPI_BIN" exec "$EPI_INSTANCE" -- "fj auth add-token --host https://git.junco.dev \"$(cat "$TOKEN")\""
fi
