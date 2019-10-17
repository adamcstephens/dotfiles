if [[ $(ls -1 ~/.gnupg/private-keys-v1.d/ | wc -l) -gt 0 ]]
then
  pgrep gpg-agent &>/dev/null || eval $(gpg-agent --daemon)
fi
if [[ -e  ~/.gnupg/sshcontrol ]] && cat ~/.gnupg/sshcontrol | egrep -vq '^(#.*|$)'
then
  # gpg-agent to provide for ssh too
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

# if [ -f "${HOME}/.gpg-agent-info" ]; then
#      source "${HOME}/.gpg-agent-info"
#        export GPG_AGENT_INFO
#        export SSH_AUTH_SOCK
#        export SSH_AGENT_PID
# else
#     eval $( gpg-agent --daemon --write-env-file ~/.gpg-agent-info )
# fi<Paste>
