gpg_private_keys=(~/.gnupg/private-keys-v1.d/*)&>/dev/null
if [[ ${#gpg_private_keys[@]} -gt 0 ]]
then
  pgrep gpg-agent &>/dev/null || eval $(gpg-agent --daemon)
fi
if cat ~/.gnupg/sshcontrol | egrep -vq '^(#.*|$)'
then
  # gpg-agent to provide for ssh too
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi
