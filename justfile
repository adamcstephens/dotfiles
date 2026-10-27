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
    sudo $(nix build .#darwinConfigurations.willow.system --no-link --print-out-paths)/sw/bin/darwin-rebuild switch --flake ~/.dotfiles#willow

fish-bootstrap:
    fish ~/.dotfiles/bin/theme.fish

git-config email:
    git config -f ~/.gitconfig.local user.email {{ email }}

intel-check-cstate:
    sudo cat /sys/kernel/debug/pmc_core/package_cstate_show

migrate: (migrate-hjem (env("XDG_STATE_HOME", env("HOME") / ".local/state") / "hjem/standalone/current/manifest.json") (env("XDG_STATE_HOME", env("HOME") / ".local/state") / "hjem/standalone"))
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

# Remove destinations before discarding the manifest so failed unlinks can be retried.
migrate-hjem manifest state:
    #!/usr/bin/env bash
    set -euo pipefail
    manifest={{quote(manifest)}}
    state={{quote(state)}}
    if [[ ! -f "$manifest" ]]; then
        exit 0
    fi
    targets="$(mktemp)"
    trap 'rm --force -- "$targets"' EXIT
    jq --slurp --join-output '
        if length != 1 then error("expected one Hjem manifest")
        else .[0]
        | if (.files | type) != "array" then error("expected Hjem files array")
          elif all(.files[]; .target |
              if type == "string" then startswith("/") and (contains("\u0000") | not)
              else false end)
          then .files[] | .target, "\u0000"
          else error("expected absolute Hjem file targets")
          end
        end
    ' "$manifest" > "$targets"
    while IFS= read -r -d '' target; do
        if [[ -L "$target" ]]; then
            destination="$(realpath --canonicalize-missing -- "$(dirname -- "$target")")/$(basename -- "$target")"
            case "$destination" in
                /nix/store/*) continue ;;
            esac
            unlink -- "$target"
        fi
    done < "$targets"
    rm --recursive --force -- "$state"
    rm --force -- "$manifest"

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
    nix build --print-build-logs --keep-going .#homeConfigurations.deck.activationPackage .#homeConfigurations.punk.activationPackage
    nix eval .#darwinConfigurations.willow.system.drvPath
    nix eval .#nixosConfigurations.agents.config.system.build.toplevel.drvPath
    nix eval .#nixosConfigurations.agents-aarch64.config.system.build.toplevel.drvPath
