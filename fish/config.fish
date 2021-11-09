set -U fish_greeting

# paths
fish_add_path --append ~/bin
fish_add_path --append ~/.dotfiles/bin
if test -d ~/.emacs.d/bin
    fish_add_path ~/.emacs.d/bin
end
if test -d ~/go/bin
    fish_add_path ~/go/bin
end
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
end
if test -d /snap/bin
    fish_add_path /snap/bin
end

# envs
set -x EDITOR ~/bin/editor
set -x PAGER "less -r"

# direnv
if command -v direnv &>/dev/null
    direnv hook fish | source
end

# fisher
fzf_configure_bindings --directory=\ct
set fzf_fd_opts --hidden --exclude=.git

# git-subrepo
source ~/.dotfiles/git-subrepo/.fish.rc

# ripgrep
set -x RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc
if command -v rg >/dev/null
    set -x FZF_DEFAULT_COMMAND 'rg --files --hidden'
end

# starship
if command -v starship &>/dev/null
    starship init fish | source
end

# zoxide
if command -v zoxide &>/dev/null
    zoxide init fish --cmd j | source
end
