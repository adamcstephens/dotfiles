function ssh-auth-sock --on-event="fish_preexec"
    if [ -z "$XDG_RUNTIME_DIR" ]
        set sockfile $HOME/.ssh/ssh-auth.sock
    else
        set sockfile $XDG_RUNTIME_DIR/ssh-auth.sock
    end

    if [ -z "$SSH_AUTH_SOCK" ]
        rm --force $sockfile
        return 0
    end

    if [ -z "$TMUX" ] && [ -z "$ZELLIJ" ]
        if [ "$SSH_AUTH_SOCK" != "(readlink $sockfile)" ] && [ "$SSH_AUTH_SOCK" != "$sockfile" ]
            ln --symbolic --force $SSH_AUTH_SOCK $sockfile
            ssh-add -L | head --lines=1 >~/.ssh/signing-key.pub
        end
    else
        set --export SSH_AUTH_SOCK $sockfile
    end
end
