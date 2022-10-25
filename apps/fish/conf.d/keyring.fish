if status is-interactive && command -v gnome-keyring-daemon &>/dev/null
    set -x (gnome-keyring-daemon --start 2>/dev/null | string split "=")
end
