status is-interactive; and begin
    if test -d "$HOME/Applications/Ghostty.app"
        fish_add_path --append --move "$HOME/Applications/Ghostty.app/Contents/MacOS"
        if not contains "$HOME/Applications/Ghostty.app/Contents/Resources/fish/vendor_completions.d" $fish_complete_path
            set --prepend fish_complete_path "$HOME/Applications/Ghostty.app/Contents/Resources/fish/vendor_completions.d"
        end
    else if test -d "/Applications/Ghostty.app"
        fish_add_path --append --move /Applications/Ghostty.app/Contents/MacOS
        if not contains "/Applications/Ghostty.app/Contents/Resources/fish/vendor_completions.d"$fish_complete_path
            set --prepend fish_complete_path "/Applications/Ghostty.app/Contents/Resources/fish/vendor_completions.d"
        end
    end

    if test -n "$GHOSTTY_RESOURCES_DIR"
        source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
    end
end
