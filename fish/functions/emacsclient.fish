function emacsclient
    set OLDTERM $TERM
    if [ -e ~/.terminfo/x/xterm-emacs ]
        set TERM xterm-emacs
    else
        set TERM xterm-256color
    end
    command emacsclient -t $argv
    set TERM $OLDTERM
end
