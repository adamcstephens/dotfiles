#!/usr/bin/env bash

if [[ -z $1 ]]; then
  MODE=window
else
  MODE=$1
fi

OUTPUT=$(xdg-user-dir PICTURES)/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')

case $MODE in
  window)
    swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' \
      | slurp | grim -g - "$OUTPUT" && cat "$OUTPUT" | wl-copy
    ;;
  box)
    slurp | grim -g - "$OUTPUT" && cat "$OUTPUT" | wl-copy
    ;;
  screen)
    grim "$OUTPUT" && cat "$OUTPUT" | wl-copy
    ;;
  *)
    echo "Unsupported mode $MODE"
    exit 1
esac
