if status is-interactive && ! command -q nix
    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    else if test -e $HOME/.nix-profile/etc/profile.d/nix.sh
        fenv source $HOME/.nix-profile/etc/profile.d/nix.sh
    end
end

# paths
fish_add_path --prepend --move ~/bin
fish_add_path --prepend --move ~/.dotfiles/bin
