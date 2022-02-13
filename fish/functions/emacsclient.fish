function emacsclient
    if [ -e ~/.terminfo/x/xterm-emacs ] || [ -e ~/.terminfo/78/xterm-emacs ]
        set -x TERM xterm-emacs
    else
        set -x TERM xterm-256color
    end
    command emacsclient -t $argv
end
