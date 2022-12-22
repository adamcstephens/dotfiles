#!/usr/bin/env sh

case $(playerctl status) in
Playing)
  echo "$(playerctl metadata title) | $(playerctl metadata artist)"
  ;;
*) ;;
esac
