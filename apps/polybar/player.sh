#!/usr/bin/env sh

case $(playerctl status 2>/dev/null) in
Playing)
  echo "$(playerctl metadata title) | $(playerctl metadata artist)"
  ;;
*) echo "" ;;
esac
