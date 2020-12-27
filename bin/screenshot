#!/usr/bin/env bash

OUTPUT=$(xdg-user-dir PICTURES)/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')

slurp | grim -g - "$OUTPUT" && cat "$OUTPUT" | wl-copy
