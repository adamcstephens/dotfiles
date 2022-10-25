if status is-interactive
    if test -e ~/.nix-profile/etc/profile.d/hm-session-vars.sh
        fenv source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    end

    if test -e ~/.nix-profile/share/fish/vendor_completions.d
        set --prepend --export fish_complete_path ~/.nix-profile/share/fish/vendor_completions.d
    end

    if test -e ~/.nix-profile/share/fish/vendor_functions.d
        set --prepend --export fish_function_path ~/.nix-profile/share/fish/vendor_functions.d
    end

    set -x XDG_DATA_DIRS "$HOME/.nix-profile/share/:$XDG_DATA_DIRS"
end
