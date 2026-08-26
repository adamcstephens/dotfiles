default:
    just --list

bump: bump-flake bump-pins

bump-flake:
    flake-update-jj

flake-check:
    nix flake check --no-build --all-systems

bump-pins:
    npins -d npins/ update
    npins -d apps/neovim/npins/ update
    npins -d apps/neovim/npins.lazy/ update
    jj commit -m 'chore: npins update' npins/ apps/neovim/npins/ apps/neovim/npins.lazy/ || true

[env("NIX_CONFIG", "experimental-features = nix-command flakes pipe-operators pipe-operator")]
bump-packages:
    nix-update --flake arkenfox --commit

nix-darwin-bootstrap:
    sudo $(nix build .#darwin/$(hostname -s) --print-out-paths)/sw/bin/darwin-rebuild switch --flake ~/.dotfiles

fish-bootstrap:
    fish ~/.dotfiles/bin/theme.fish

git-config email:
    git config -f ~/.gitconfig.local user.email {{ email }}

intel-check-cstate:
    sudo cat /sys/kernel/debug/pmc_core/package_cstate_show

migrate:
    # 2026-01-09
    @if [ -h "$HOME/.config/fish" ]; then rm -v "$HOME/.config/fish"; fi
    # 2026-06-17
    @if [ -h "$HOME/.config/epi" ]; then rm -v "$HOME/.config/epi"; fi
    # 2026-07-04
    # may be a bit of a hack to ensure we purge fish's own init
    @if [ ! -h "$HOME/.config/fish/completions" ]; then rm -rfv "$HOME/.config/fish/completions"; fi
    @if [ ! -h "$HOME/.config/fish/conf.d" ]; then rm -rfv "$HOME/.config/fish/conf.d"; fi
    @if [ ! -h "$HOME/.config/fish/config.fish" ]; then rm -fv "$HOME/.config/fish/config.fish"; fi
    @if [ ! -h "$HOME/.config/fish/functions" ]; then rm -rfv "$HOME/.config/fish/functions"; fi
    @true

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
