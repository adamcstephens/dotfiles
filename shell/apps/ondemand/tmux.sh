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

function tm() {
  tmux attach-session || tmux new-session
}

# copy this as an alternative future option
# if [ -n "$TMUX" ]; then
#   TMUX_SESSION=`tmux display-message -p '#S'`
#   SOCK="$HOME/.ssh/.ssh-agent-$USER-tmux-$TMUX_SESSION"
#   if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]; then
#     rm -f $SOCK
#     ln -sf $SSH_AUTH_SOCK $SOCK
#     export SSH_AUTH_SOCK=$SOCK
#   fi
# fi
