# Only execute this file once per shell.
set -q __fish_dotfiles_config_sourced; and exit
set --global __fish_dotfiles_config_sourced 1

fish_add_path --prepend --move $HOME/.dotfiles/bin

if test -d "$HOME/.local/state/hjem/standalone/current-profile"
    fish_add_path --prepend --move "$HOME/.local/state/hjem/standalone/current-profile/sbin"
    fish_add_path --prepend --move "$HOME/.local/state/hjem/standalone/current-profile/bin"
end

if ! grep nixos /etc/os-release >/dev/null 2>&1
    set --export TERMINFO_DIRS $HOME/.nix-profile/share/terminfo

    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    end

    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
    end
end

status is-login; and begin
end

status is-interactive; and begin

    # Abbreviations
    abbr --add -- cat bat
    abbr --add -- cnf command-not-found
    abbr --add -- da 'direnv allow'
    abbr --add -- db 'direnv block'
    abbr --add -- dc docker compose
    abbr --add -- dclf 'docker-compose logs --tail=100 -f'
    abbr --add -- dog doggo
    abbr --add -- dps 'docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}"'
    abbr --add -- f fossil
    abbr --add -- fs 'fossil status'
    abbr --add -- ga 'git add'
    abbr --add -- gbv 'git branch --all --verbose --verbose'
    abbr --add -- gc 'git commit'
    abbr --add -- gco 'git checkout'
    abbr --add -- gd 'git diff'
    abbr --add -- gl 'git pull'
    abbr --add -- glo 'git log --date=iso --format="%C(auto)%h %C(auto,blue)[%ar]%C(auto)%d %s" --max-count=15'
    abbr --add -- gp 'git push'
    abbr --add -- grh 'git reset HEAD'
    abbr --add -- grv 'git remote -v'
    abbr --add -- gs 'git status'
    abbr --add -- gss 'git status --short'
    abbr --add -- gsw 'git switch'
    abbr --add -- gswc 'git switch --create'
    abbr --add -- gt 'git tag --list -n1'
    abbr --add -- gw 'git worktree'
    abbr --add -- ivl 'sudo iptables -vnL --line-numbers'
    abbr --add -- jc 'sudo journalctl'
    abbr --add -- jcu 'journalctl --user'
    abbr --add -- jjbm 'jj bookmark move --to @-'
    abbr --add -- jjc 'jj commit'
    abbr --add -- jjd 'jj diff'
    abbr --add -- jjgf 'jj git fetch --all-remotes'
    abbr --add -- jjgp 'jj git push'
    abbr --add -- jjl 'jj log --limit 10'
    abbr --add -- l 'll -a'
    abbr --add -- la 'eza -a'
    abbr --add -- ll 'eza -lg'
    abbr --add -- lla 'eza -la'
    abbr --add -- ls eza
    abbr --add -- lt 'eza --tree'
    abbr --add -- sy 'sudo systemctl'
    abbr --add -- syu 'systemctl --user'
    abbr --add -- tree 'eza --tree'

    # Interactive shell initialisation

    set --universal __done_notification_urgency_level_failure normal
    set --universal fish_greeting

    set --export SSH_AUTH_SOCK (ssh-agent-mgr)
    source $HOME/.config/fish/functions/ssh-auth-sock.fish

    source $HOME/.config/fish/functions/_smart-splits.fish

    if test -e $HOME/.shell_local.fish
        source $HOME/.shell_local.fish
    end

    set --export PAGER $HOME/.dotfiles/bin/pager
    set --export EDITOR $HOME/.dotfiles/bin/editor

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

    fzf --fish | source
    set --export FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    if command --query zoxide
        zoxide init fish --cmd j | source
    end

    if test "$TERM" != dumb && command --query starship
        starship init fish | source
    end

    if command --query atuin
        atuin init fish --disable-up-arrow | source
    end

    direnv hook fish | source
end
