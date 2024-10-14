default:
    just --list

bump: bump-flake bump-pins bump-packages

bump-flake:
    nix flake update --commit-lock-file

flake-check:
    nix flake check --no-build --all-systems

bump-pins:
    npins update -d npins/
    npins update -d apps/emacs/npins-packages/
    npins update -d apps/neovim/npins/
    npins update -d apps/neovim/npins-ext/
    git add npins/ apps/emacs/npins-packages/ apps/neovim/npins/ apps/neovim/npins-ext/
    git commit -m 'chore: npins update' -- npins/ apps/emacs/npins-packages/ apps/neovim/npins/ apps/neovim/npins-ext/ || true

bump-packages:
    nix-update --flake arkenfox --commit

nix-darwin-bootstrap:
    eval $(nix build .#darwin/$(hostname -s) --print-out-paths)/sw/bin/darwin-rebuild switch --flake ~/.dotfiles

fish-bootstrap:
    fish ~/.dotfiles/bin/theme.fish

git-config email:
    git config -f ~/.gitconfig.local user.email {{ email }}

intel-check-cstate:
    sudo cat /sys/kernel/debug/pmc_core/package_cstate_show

migrate:
    true

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

systemd-networkd-debug:
    sudo mkdir -p /run/systemd/system/systemd-networkd.service.d
    echo -e "[Service]\nEnvironment=SYSTEMD_LOG_LEVEL=debug" | sudo tee /run/systemd/system/systemd-networkd.service.d/override.conf
    sudo systemctl daemon-reload

systemd-networkd-debug-reset:
    sudo rm /run/systemd/system/systemd-networkd.service.d/override.conf
    sudo systemctl daemon-reload
    sudo systemctl systemd-networkd

test:
    nix build --print-build-logs --keep-going .#homeConfigurations.aarch64-darwin.activationPackage .#homeConfigurations.aarch64-linux.activationPackage .#homeConfigurations.think.activationPackage
