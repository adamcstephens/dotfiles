set TERMINFO $HOME/.terminfo

if [ -e ~/.terminfo/78/xterm-screen-256color ]
    set TERM xterm-screen-256color
end

# custom terminal overrides
if [ $TERM = xterm-screen-256color ]
    set -l NEWTERM xterm-256color
    for app in lxc multipass ssh
        if command -v $app >/dev/null
            alias $app="TERM=$NEWTERM command $app"
        end
    end
end