#!/usr/bin/env fish

set pkgs (cat ~/.dotfiles/fish/fish_plugins)

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

source ~/.dotfiles/fish/functions/fisher.fish

for pkg in $pkgs
    fisher install $pkg
end
