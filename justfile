default:
    just --list

aqua-run:
    cd ./aqua; aqua install

bootstrap-nonix: aqua-run dotbot fish-bootstrap

brew-dump:
    brew bundle dump --all --force
    git diff Brewfile

dotbot config="":
    CONFIG={{config}} ~/.dotfiles/bin/dotbot

fish-bootstrap:
    fish ~/.dotfiles/bin/theme.fish

migrate:
    #!/usr/bin/env bash
    set -e
    if [ -h $HOME/.config/direnv ]; then rm -rfv $HOME/.config/direnv; fi
    if [ -e $HOME/.config/fish/config.fish && ! -h $HOME/.config/fish/config.fish ]; then rm -v $HOME/.config/fish/config.fish; fi

    if [ -d $HOME/.dotfiles/dotbot ]; then rm -rfv $HOME/.dotfiles/dotbot; fi
    if [ -f $HOME/.dotfiles/fish/fish_variables ]; then mv -v $HOME/.dotfiles/fish/fish_variables $HOME/.dotfiles/apps/fish/; fi
    if [ -d $HOME/.dotfiles/fish ]; then rm -rfv $HOME/.dotfiles/fish; fi
    if [ -d $HOME/.dotfiles/btop ]; then rm -rfv $HOME/.dotfiles/btop; fi

nix-index-fetch:
    #!/usr/bin/env bash
    set -e
    filename="index-x86_64-$(uname | tr A-Z a-z)"
    mkdir -p ~/.cache/nix-index
    cd ~/.cache/nix-index
    wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
    ln -f $filename files

nix-upgrade:
    sudo nix-channel --update
    sudo nix-env -iA nixpkgs.nix nixpkgs.cacert
    sudo systemctl daemon-reload
    sudo systemctl restart nix-daemon

ssh-keygen:
    ssh-keygen -t ed25519
