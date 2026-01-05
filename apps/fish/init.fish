fish_add_path --prepend --move ~/.dotfiles/bin

if ! grep nixos /etc/os-release >/dev/null 2>&1
    set -x TERMINFO_DIRS $HOME/.nix-profile/share/terminfo

    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    end

    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
    end

    if test -e $HOME/.nix-profile/share/fish/completions
        set --prepend --export fish_complete_path ~/.nix-profile/share/fish/completions
    end
end
