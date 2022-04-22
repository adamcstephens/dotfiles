#!/usr/bin/env fish

source ~/.dotfiles/fish/functions/fisher.fish

for pkg in (cat ~/.dotfiles/fish/fish_plugins)
    fisher install $pkg
end
