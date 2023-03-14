#!/usr/bin/env sh

echo $PATH

if command -v m1ddc 2>&1 >/dev/null; then
  current=$(m1ddc get input)

  if [ "$current" = "15" ]; then
    m1ddc set input 17
  else
    m1ddc set input 15
  fi
elif command -v ddcutil 2>&1 >/dev/null; then
  # Feature: 60 (Input Source)
  #    Values:
  #       10: DisplayPort-2
  #       0f: DisplayPort-1
  #       11: HDMI-1

  current=$(ddcutil getvcp 60 | sed -n "s/.*(sl=\(.*\))/\1/p")

  if [ "$current" = "0x0f" ]; then
    ddcutil setvcp 60 0x11
  else
    ddcutil setvcp 60 0x0f
  fi
else
  echo "No supported DDC command found!!"
  exit 1
fi
