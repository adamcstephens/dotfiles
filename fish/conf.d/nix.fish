if status is-interactive
    fenv source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

    set -x XDG_DATA_DIRS "$HOME/.nix-profile/share/:$XDG_DATA_DIRS"
end
