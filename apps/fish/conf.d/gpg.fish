if status is-interactive
    set -x GPG_TTY (tty)

    if command -q gpgconf && [ -n "$XDG_RUNTIME_DIR" ] && [ -d "$XDG_RUNTIME_DIR" ]
        [ -e "(gpgconf --list-dirs agent-socket)" ] || gpgconf --create-socketdir
    end
end
