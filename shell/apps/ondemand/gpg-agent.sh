# gpg-agent to provide for ssh too
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
pgrep gpg-agent &>/dev/null || eval $(gpg-agent --daemon)