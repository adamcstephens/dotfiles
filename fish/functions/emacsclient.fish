function emacsclient
    if [ -e ~/.terminfo/78/xterm-emacs ]
        export TERM=xterm-emacs
    else
        export TERM=xterm-256color
    end
    command emacsclient -t $argv
end
