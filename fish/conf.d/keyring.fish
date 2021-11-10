if command -v gnome-keyring-daemon &>/dev/null
    gnome-keyring-daemon --start --components=pkcs11,secrets,ssh 2>/dev/null | read --line ssh_auth_sock

    set -gx SSH_AUTH_SOCK (string split -m 1 = $ssh_auth_sock)[2]
end
