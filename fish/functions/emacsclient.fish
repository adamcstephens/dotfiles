function emacsclient
    if command -q systemctl && [ -e ~/.config/systemd/user/emacs.service ]
        emacs --bg-daemon
    else if ! pgrep emacs &>/dev/null
        emacs --bg-daemon
    end

    set OLDTERM $TERM
    if [ -e ~/.terminfo/x/xterm-emacs ] || [ -e ~/.terminfo/78/xterm-emacs ]
        set TERM xterm-emacs
    else
        set TERM xterm-256color
    end
    command emacsclient -t $argv
    set TERM $OLDTERM
end
