set -U __done_notification_urgency_level_failure normal
set -U fish_greeting

fzf_configure_bindings --directory=\ct
set fzf_fd_opts --hidden --exclude=.git

set -x SSH_AUTH_SOCK (~/.dotfiles/bin/ssh-agent-mgr)

if [ -e $HOME/.shell_local.sh ]
    fenv source $HOME/.shell_local.sh
end

if string match -q "$TERM_PROGRAM" vscode
    if ! command -q code
        set VSCODE_PATH (echo $BROWSER | sed 's,helpers/browser.sh,remote-cli,')
        if test -d $VSCODE_PATH
            fish_add_path $VSCODE_PATH
        end
    end

    if command -q code
        . (code --locate-shell-integration-path fish 2>/dev/null | sed 's/shellIntegration-fish/shellIntegration/')
    end
end

abbr --add gco git checkout

set -g pure_color_mute 696969
set -g pure_color_hostname yellow
set -g pure_color_git_branch magenta
set -g pure_color_git_stash magenta

set -x PAGER ~/.dotfiles/bin/pager
