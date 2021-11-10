if [ -z $SSH_AUTH_SOCK ] && [ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]
    set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
end

if [ -n $SSH_AUTH_SOCK ] && ! ssh-add -l &>/dev/null
    if [ (uname) = Darwin ]
        ssh-add --apple-use-keychain
    else
        echo "Emtpy ssh-agent"
    end
end
