if status is-interactive
    if [ -z "$SSH_AUTH_SOCK" ] && [ -S "$XDG_RUNTIME_DIR/ssh-agent" ]
        set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent"
    end

    if [ -n $SSH_AUTH_SOCK ] && ! ssh-add -l &>/dev/null
        if [ (uname) = Darwin ]
            ssh-add --apple-use-keychain
        else
            echo "Emtpy ssh-agent"
        end
    end
end
