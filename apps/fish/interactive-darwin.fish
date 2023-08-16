if [ -n $SSH_AUTH_SOCK ] && ! ssh-add -l &>/dev/null
    ssh-add --apple-use-keychain
end
