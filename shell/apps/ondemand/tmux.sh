update_auth_sock() {
  local socket_path="$(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')"

  if ! [[ "$socket_path" ]]; then
    echo 'no socket path' >&2
    return 1
  else
    export SSH_AUTH_SOCK="$socket_path"
  fi
}

alias uas=update_auth_sock
