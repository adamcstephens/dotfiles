default:
    just --list

arkenfox:
    nix run .#arkenfox

arkenfox-update: && arkenfox
    nix run nixpkgs#nix-update -- --flake arkenfox --commit

brew-dump:
    brew bundle dump --formula --cask --tap --mas --force
    git diff Brewfile

bump: bump-flake bump-npins flake-check

bump-flake:
    nix flake update --commit-lock-file

flake-check:
    nix flake check --no-build --all-systems

bump-npins:
    npins update -d npins/
    npins update -d apps/neovim/npins/
    npins update -d apps/neovim/npins-ext/
    git add npins/ apps/neovim/npins/ apps/neovim/npins-ext/
    git commit -m 'chore: npins update' -- npins/ apps/neovim/npins/ apps/neovim/npins-ext/

firefox-config: arkenfox
    ~/.dotfiles/bin/firefox-customize

nix-darwin-bootstrap:
    eval $(nix build .#darwin/$(hostname) --print-out-paths)/sw/bin/darwin-rebuild switch --flake ~/.dotfiles

fish-bootstrap:
    fish ~/.dotfiles/bin/theme.fish

git-config email:
    git config -f ~/.gitconfig.local user.email {{ email }}

intel-check-cstate:
    sudo cat /sys/kernel/debug/pmc_core/package_cstate_show

migrate:
    [ ! -e $HOME/.cache/nix-index ] || rm -rf $HOME/.cache/nix-index
    [ ! -h $HOME/.config/nvim ] || rm $HOME/.config/nvim

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
