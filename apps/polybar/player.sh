#!/usr/bin/env sh

case $(playerctl status 2>/dev/null) in
Playing)
  title="$(playerctl metadata title)"
  artist="$(playerctl metadata artist)"
  printf "%s" "$title"
  [ -n "$artist" ] && printf '\- %s' "$artist"
  echo
  ;;
*) echo "" ;;
esac
