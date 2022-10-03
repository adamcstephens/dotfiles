default:
    just --list

brew-dump:
    brew bundle dump --all --force
    git diff Brewfile

nix-upgrade:
    sudo nix-channel --update
    sudo nix-env -iA nixpkgs.nix nixpkgs.cacert
    sudo systemctl daemon-reload
    sudo systemctl restart nix-daemon
