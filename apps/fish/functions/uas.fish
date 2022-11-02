function uas
    set -x SSH_AUTH_SOCK $(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')
end
