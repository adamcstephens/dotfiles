#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gh

gh auth token | "$EPI_BIN" exec "$EPI_INSTANCE" -- "gh auth login --with-token"
