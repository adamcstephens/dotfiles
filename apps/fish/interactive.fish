set -U __done_notification_urgency_level_failure normal
set -U fish_greeting

set -x SSH_AUTH_SOCK (ssh-agent-mgr)

if test -e $HOME/.shell_local.fish
    source $HOME/.shell_local.fish
end

abbr --add gco git checkout

set -x PAGER ~/.dotfiles/bin/pager
set -x EDITOR ~/.dotfiles/bin/editor

# fish made word/token platform dependent, so we'll hardcode these
bind alt-backspace backward-kill-word
bind alt-delete kill-word
bind alt-left prevd-or-backward-word
bind alt-right nextd-or-forward-word
bind ctrl-alt-h backward-kill-word
bind ctrl-backspace backward-kill-token
bind ctrl-delete kill-token
bind ctrl-h backward-kill-token
bind ctrl-left backward-token
bind ctrl-right forward-token
