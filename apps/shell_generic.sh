# shellcheck shell=bash disable=SC1091

# shellcheck disable=SC1090
[[ -e "$HOME/.shell_local.sh" ]] && . "$HOME/.shell_local.sh"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PAGER="$HOME/.dotfiles/bin/pager"
export EDITOR="$HOME/.dofiles/bin/editor"

# shell
# shellcheck disable=SC2139
alias esl="exec $SHELL -l"

# custom terminal overrides
if [[ "$TERM" == "xterm-screen-256color" ]]; then
  NEWTERM="xterm-256color"
  alias lxc='TERM=$NEWTERM lxc'
  alias multipass='TERM=$NEWTERM multipass'
  alias ssh='TERM=$NEWTERM ssh'
  export TERMINFO=$HOME/.terminfo
elif [[ "$TERM" == "xterm-kitty" ]]; then
  alias ssh="kitty +kitten ssh"
  export TERMINFO=$HOME/.terminfo
fi

# passwords
if command -v pwgen >/dev/null; then
  alias pwgen='pwgen -csn1 20 12'
fi

# app specific
#

# gsed
if command -v gsed >/dev/null; then
  alias sed=gsed
fi

# nix
if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME"/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

# python
export PYTHONSTARTUP="$HOME"/.dotfiles/apps/python/pythonstartup.py

# ssh
if [[ -n $SSH_AUTH_SOCK ]] && ! ssh-add -l &>/dev/null; then
  echo "Empty ssh-agent"
fi

# tmux
update_auth_sock() {
  socket_path="$(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')"

  if ! [ -e "$socket_path" ]; then
    echo 'no socket path' >&2
    return 1
  else
    export SSH_AUTH_SOCK="$socket_path"
  fi
}
alias uas=update_auth_sock
