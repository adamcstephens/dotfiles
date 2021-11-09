set -U fish_greeting

# paths
fish_add_path ~/bin
fish_add_path ~/.dotfiles/bin
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end

# envs
set EDITOR ~/bin/editor

# asdf
if test -e ~/.asdf/asdf.fish
    source ~/.asdf/asdf.fish
    if ! test -e ~/.config/fish/completions/asdf.fish
        ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    end
end

# direnv
if command -v direnv &>/dev/null
    direnv hook fish | source
end

# fisher
fzf_configure_bindings --directory=\ct
set fzf_fd_opts --hidden --exclude=.git

# git-subrepo
source ~/.dotfiles/git-subrepo/.fish.rc

# starship
if command -v starship &>/dev/null
    starship init fish | source
end

# zoxide
if command -v zoxide &>/dev/null
    zoxide init fish --cmd j | source
end
