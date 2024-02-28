function ssh-auth-sock --on-event="fish_preexec"
    set sockfile $XDG_RUNTIME_DIR/ssh-auth.sock

    if [ -z "$SSH_AUTH_SOCK" ]
        rm -f $sockfile
        return 0
    end

    if [ -z "$TMUX" ] && [ -z "$ZELLIJ" ]
        ln -sf $SSH_AUTH_SOCK $sockfile
    else
        set -x SSH_AUTH_SOCK $sockfile
    end
end
