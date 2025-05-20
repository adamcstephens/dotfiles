# shellcheck shell=bash disable=SC1091

export PATH="$HOME/.dotfiles/bin:$PATH"

[[ -e "$HOME/.shell_local.sh" ]] && . "$HOME/.shell_local.sh"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# shell
alias esl="exec \$SHELL -l"

# nix
if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME"/.nix-profile/etc/profile.d/hm-session-vars.sh
fi
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi
if [ -d /run/current-system/sw/bin ]; then
  export PATH="$PATH:/run/current-system/sw/bin"
fi

# ssh
SSH_AUTH_SOCK="$(ssh-agent-mgr)"
export SSH_AUTH_SOCK
