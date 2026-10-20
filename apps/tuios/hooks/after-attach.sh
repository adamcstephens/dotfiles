#!/usr/bin/env bash

TUIOS_AGENT=$(tuios ssh-agent-path)

if [ -z "$XDG_RUNTIME_DIR" ]; then
  sockfile="$HOME/.ssh/ssh-auth.sock"
else
  sockfile="$XDG_RUNTIME_DIR/ssh-auth.sock"
fi

if [ -S "$TUIOS_AGENT" ] && [ "$(readlink -f "$sockfile")" != "$TUIOS_AGENT" ]; then
  ln -sf "$TUIOS_AGENT" "$sockfile"
  SSH_AUTH_SOCK="$sockfile" ssh-add -L | head --lines=1 >"$HOME"/.ssh/signing-key.pub
fi

touch /tmp/testfile
