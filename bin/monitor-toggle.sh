#!/usr/bin/env sh

if command -v m1ddc 2>&1 >/dev/null; then
  current=$(m1ddc get input)

  if [ "$current" = "15" ]; then
    m1ddc set input 17
  else
    m1ddc set input 15
  fi
fi
