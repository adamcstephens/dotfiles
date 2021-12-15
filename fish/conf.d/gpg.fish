if status is-interactive
  set -x GPG_TTY (tty)
end

if command -v gpgconf > /dev/null && [ -n "$XDG_RUNTIME_DIR" ] && [ -d "$XDG_RUNTIME_DIR" ]]
  [ -e "(gpgconf --list-dirs agent-socket)" ] || gpgconf --create-socketdir
end
