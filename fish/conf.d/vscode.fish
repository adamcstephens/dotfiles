if status is-interactive && string match -q "$TERM_PROGRAM" vscode
    if ! command -q code
        set VSCODE_PATH (echo $BROWSER | sed 's,helpers/browser.sh,remote-cli,')
        if test -d $VSCODE_PATH
            fish_add_path $VSCODE_PATH
        end
    end

    if command -q code
        . (code --locate-shell-integration-path fish 2>/dev/null | sed 's/shellIntegration-fish/shellIntegration/')
    end
end
