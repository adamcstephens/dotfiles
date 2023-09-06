default:
    just --list

brew-dump:
    brew bundle dump --formula --cask --tap --mas --force
    git diff Brewfile

bump:
    nix flake update --commit-lock-file
    nix run .#hm-all
    git push

fish-bootstrap:
    fish ~/.dotfiles/bin/theme.fish

git-config email:
    git config -f ~/.gitconfig.local user.email {{ email }}

intel-check-cstate:
    sudo cat /sys/kernel/debug/pmc_core/package_cstate_show

nix-upgrade:
    sudo nix-channel --update
    sudo nix-env -iA nixpkgs.nix nixpkgs.cacert
    sudo systemctl daemon-reload
    sudo systemctl restart nix-daemon

ssh-keygen:
    ssh-keygen -t ed25519

steam-bootstrap:
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub com.valvesoftware.Steam

test:
    nix build --print-build-logs --keep-going .#homeConfigurations.aarch64-darwin.activationPackage .#homeConfigurations.aarch64-linux.activationPackage .#homeConfigurations.think.activationPackage
