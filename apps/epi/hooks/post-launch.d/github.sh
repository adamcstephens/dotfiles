#!/usr/bin/env bash

gh auth token | "$EPI_BIN" exec "$EPI_INSTANCE" -- "gh auth login --with-token"
