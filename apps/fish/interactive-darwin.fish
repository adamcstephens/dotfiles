if [ -z "$XDG_RUNTIME_DIR" ]
    set -x XDG_RUNTIME_DIR /run/user/(id -u)
end

if [ -n $SSH_AUTH_SOCK ] && ! ssh-add -l &>/dev/null
    ssh-add --apple-use-keychain
end
