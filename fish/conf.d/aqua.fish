if status is-interactive
    if test -d ~/.local/share/aquaproj-aqua/bin
        fish_add_path ~/.local/share/aquaproj-aqua/bin
    end

    if [ -x (command -v aqua) ]
        set -x AQUA_GLOBAL_CONFIG ~/.config/aquaproj-aqua/aqua.yaml
    end
end
