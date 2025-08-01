set -U __done_notification_urgency_level_failure normal
set -U fish_greeting

set -x SSH_AUTH_SOCK (ssh-agent-mgr)

if test -e $HOME/.shell_local.fish
    source $HOME/.shell_local.fish
end

abbr --add gco git checkout

set -x PAGER ~/.dotfiles/bin/pager
set -x EDITOR ~/.dotfiles/bin/editor
