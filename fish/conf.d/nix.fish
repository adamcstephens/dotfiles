if status is-interactive
    if test -e ~/.nix-profile/etc/profile.d/hm-session-vars.sh
        fenv source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    end

    set -x XDG_DATA_DIRS "$HOME/.nix-profile/share/:$XDG_DATA_DIRS"
end
