function emacs
    set OLDTERM $TERM
    if [ -e ~/.terminfo/x/xterm-emacs ] || [ -e ~/.terminfo/78/xterm-emacs ]
        set TERM xterm-emacs
    else
        set TERM xterm-256color
    end
    command emacs -nw $argv
    set TERM $OLDTERM
end
