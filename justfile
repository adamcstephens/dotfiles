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

nix-upgrade:
    sudo nix-channel --update
    sudo nix-env -iA nixpkgs.nix nixpkgs.cacert
    sudo systemctl daemon-reload
    sudo systemctl restart nix-daemon

ssh-keygen:
    ssh-keygen -t ed25519
