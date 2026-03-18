#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gojq

if [ ! -e ~/.claude ]; then
  mkdir -vp ~/.claude
fi

if [ -f ~/.claude.json ] && [ ! -h ~/.claude.json ]; then
  mv ~/.claude.json ~/.claude/.claude.json
fi

if [ ! -e ~/.claude/.claude.json ]; then
  echo "{}" >~/.claude/.claude.json
fi

"$EPI_BIN" exec "$EPI_INSTANCE" -- "test -h ~/.claude.json || ln -s ~/.claude/.claude.json ~/.claude.json"
