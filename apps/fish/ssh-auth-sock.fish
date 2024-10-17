function ssh-auth-sock --on-event="fish_preexec"
    if [ -z "$XDG_RUNTIME_DIR" ]
        set sockfile $HOME/.ssh/ssh-auth.sock
    else
        set sockfile $XDG_RUNTIME_DIR/ssh-auth.sock
    end

    if [ -z "$SSH_AUTH_SOCK" ]
        rm -f $sockfile
        return 0
    end

    if [ -z "$TMUX" ] && [ -z "$ZELLIJ" ]
        if [ "$SSH_AUTH_SOCK" != "(readlink $sockfile)" ]
            ln -sf $SSH_AUTH_SOCK $sockfile
            ssh-add -L | head -n 1 >~/.ssh/signing-key.pub
        end
    else
        set -x SSH_AUTH_SOCK $sockfile
    end
end
