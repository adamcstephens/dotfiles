if status is-interactive
    if ! test -e /nix
        set -x AQUA_GLOBAL_CONFIG ~/.config/aquaproj-aqua/aqua.yaml

        if test -d ~/.local/share/aquaproj-aqua/bin
            fish_add_path --append ~/.local/share/aquaproj-aqua/bin
        end
    end
end
