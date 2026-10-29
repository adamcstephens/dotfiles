#!/usr/bin/env bash

for attempt in {1..5}; do
  if gh auth token | "$EPI_BIN" exec "$EPI_INSTANCE" -- "gh auth login --with-token"; then
    exit 0
  fi
  if ((attempt < 5)); then
    sleep 1
  fi
done

exit 1
