#!/usr/bin/env bash

set -e

if [[ -z "$1" ]]; then
  MODE=window
else
  MODE=$1
fi

if [[ -n "$WAYLAND_DISPLAY" ]]; then
  GUI="wayland"
else
  GUI="xorg"
fi

OUTPUT="$HOME"/sync/pictures/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')

if [ ! -d "$(dirname "$OUTPUT")" ]; then
  mkdir -vp "$(dirname "$OUTPUT")"
fi

case $MODE in
window)
  if [ $GUI = "xorg" ]; then
    maim -i "$(xdotool getactivewindow)" "$OUTPUT"
  else
    case "$XDG_CURRENT_DESKTOP" in
    niri)
      niri msg action screenshot-window
      ;;
    *)
      echo "window mode unsupported on wayland"
      exit 1
      ;;
    esac
  fi
  ;;

box)
  if [ $GUI = "xorg" ]; then
    maim -s "$OUTPUT"
  else
    case "$XDG_CURRENT_DESKTOP" in
    niri)
      niri msg action screenshot
      ;;
    *)
      slurp | grim -g - "$OUTPUT"
      ;;
    esac
  fi
  ;;

screen)
  if [ $GUI = "xorg" ]; then
    maim "$OUTPUT"
  else
    case "$XDG_CURRENT_DESKTOP" in
    niri)
      niri msg action screenshot
      ;;
    *)
      grim "$OUTPUT"
      ;;
    esac
  fi
  ;;

*)
  echo "Unsupported mode $MODE"
  exit 1
  ;;
esac

if [ $GUI = "xorg" ]; then
  xclip -selection clipboard -target image/png -i <"$OUTPUT"
else
  case "$XDG_CURRENT_DESKTOP" in
  niri)
    niri msg action screenshot
    ;;
  *)
    wl-copy <"$OUTPUT"
    ;;
  esac
fi
