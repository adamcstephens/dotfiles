# Only execute this file once per shell.
set -q __fish_dotfiles_config_sourced; and exit
set -g __fish_dotfiles_config_sourced 1

fish_add_path --prepend --move $HOME/.dotfiles/bin

if ! grep nixos /etc/os-release >/dev/null 2>&1
    set -x TERMINFO_DIRS $HOME/.nix-profile/share/terminfo

    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    end

    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
    end

    if test -e $HOME/.nix-profile/share/fish/completions
        set --prepend --export fish_complete_path $HOME/.nix-profile/share/fish/completions
    end
end

status is-login; and begin
end

status is-interactive; and begin

    # Abbreviations
    abbr --add -- cnf command-not-found
    abbr --add -- da 'direnv allow'
    abbr --add -- db 'direnv block'
    abbr --add -- dc docker-compose
    abbr --add -- dclf 'docker-compose logs --tail=100 -f'
    abbr --add -- dog doggo
    abbr --add -- dps 'docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}"'
    abbr --add -- f fossil
    abbr --add -- fs 'fossil status'
    abbr --add -- ga 'git add'
    abbr --add -- gbv 'git branch --all --verbose --verbose'
    abbr --add -- gc 'git commit'
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
    abbr --add -- l 'll -a'
    abbr --add -- ll 'eza -lg'
    abbr --add -- sy 'sudo systemctl'
    abbr --add -- syu 'systemctl --user'
    abbr --add -- tree 'eza --tree'

    # Aliases
    alias cat bat
    alias cnf command-not-found
    alias da 'direnv allow'
    alias db 'direnv block'
    alias dc docker-compose
    alias dclf 'docker-compose logs --tail=100 -f'
    alias dog doggo
    alias dps 'docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}"'
    alias f fossil
    alias fs 'fossil status'
    alias ga 'git add'
    alias gbv 'git branch --all --verbose --verbose'
    alias gc 'git commit'
    alias gd 'git diff'
    alias gl 'git pull'
    alias glo 'git log --date=iso --format="%C(auto)%h %C(auto,blue)[%ar]%C(auto)%d %s" --max-count=15'
    alias gp 'git push'
    alias grh 'git reset HEAD'
    alias grv 'git remote -v'
    alias gs 'git status'
    alias gss 'git status --short'
    alias gsw 'git switch'
    alias gswc 'git switch --create'
    alias gt 'git tag --list -n1'
    alias gw 'git worktree'
    alias ivl 'sudo iptables -vnL --line-numbers'
    alias jc 'sudo journalctl'
    alias jcu 'journalctl --user'
    alias jjbm 'jj bookmark move --to @-'
    alias jjc 'jj commit'
    alias jjd 'jj diff'
    alias jjgf 'jj git fetch --all-remotes'
    alias jjgp 'jj git push'
    alias l 'll -a'
    alias la 'eza -a'
    alias ll 'eza -lg'
    alias lla 'eza -la'
    alias ls eza
    alias lt 'eza --tree'
    alias nix 'nix --print-build-logs'
    alias sy 'sudo systemctl'
    alias syu 'systemctl --user'
    alias tree 'eza --tree'

    # Interactive shell initialisation

    set -U __done_notification_urgency_level_failure normal
    set -U fish_greeting

    set -x SSH_AUTH_SOCK (ssh-agent-mgr)
    source $HOME/.config/fish/functions/ssh-auth-sock.fish

    source $HOME/.config/fish/functions/_smart-splits.fish

    if test -e $HOME/.shell_local.fish
        source $HOME/.shell_local.fish
    end

    abbr --add gco git checkout

    set -x PAGER $HOME/.dotfiles/bin/pager
    set -x EDITOR $HOME/.dotfiles/bin/editor

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
    set -x FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    if test -n "$KITTY_WINDOW_ID"
        source $HOME/.config/fish/functions/autodark.fish
    end

    zoxide init fish --cmd j | source

    if test "$TERM" != dumb
        starship init fish | source
    end

    function __fish_command_not_found_handler --on-event fish_command_not_found
        /nix/store/vjszj5c5k5ccwqgdnz8378gbbkfxdnys-command-not-found $argv
    end

    atuin init fish --disable-up-arrow | source

    direnv hook fish | source

    # add completions generated by Home Manager to $fish_complete_path
    begin
        set -l joined (string join " " $fish_complete_path)
        set -l prev_joined (string replace --regex "[^\s]*generated_completions.*" "" $joined)
        set -l post_joined (string replace $prev_joined "" $joined)
        set -l prev (string split " " (string trim $prev_joined))
        set -l post (string split " " (string trim $post_joined))
        set fish_complete_path $prev "$HOME/.local/share/fish/home-manager/generated_completions" $post
    end

end
