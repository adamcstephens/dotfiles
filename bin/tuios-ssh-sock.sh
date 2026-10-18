#!/usr/bin/env sh
# Point ~/.ssh/agent.sock at the agent of the client that attached last.
if [ -z "$XDG_RUNTIME_DIR" ]; then
  sockfile="$HOME/.ssh/ssh-auth.sock"
else
  sockfile="$XDG_RUNTIME_DIR/ssh-auth.sock"
fi

tuios subscribe --types client-session-changed | while read -r ev; do
  [ "$(printf '%s' "$ev" | gojq -r '.attached')" = true ] || continue
  pid=$(printf '%s' "$ev" | gojq -r '.pid')
  sock=$(tr '\0' '\n' <"/proc/$pid/environ" 2>/dev/null | sed -n 's/^SSH_AUTH_SOCK=//p')
  echo "Linking: $sockfile -> $sock"
  [ -S "$sock" ] && ln -sfn "$sock" "$sockfile"
done
