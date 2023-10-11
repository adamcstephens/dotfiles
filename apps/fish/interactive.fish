set -U __done_notification_urgency_level_failure normal
set -U fish_greeting

fzf_configure_bindings --directory=\ct
set fzf_fd_opts --hidden --exclude=.git

if [ -z "$SSH_AUTH_SOCK" ]
    if [ -S "$XDG_RUNTIME_DIR/ssh-agent" ]
        set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent"
    end
    if [ -S "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock" ]
        set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock"
    end
end

if [ -n $SSH_AUTH_SOCK ] && [ ! -S "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock" ] && ! ssh-add -l &>/dev/null
    echo "Emtpy ssh-agent"
end

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
abbr --add deplart --set-cursor=! "nix run .#deplart/!"
