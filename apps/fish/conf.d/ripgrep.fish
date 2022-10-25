if status is-interactive
    set -x RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc
    if command -v rg >/dev/null
        set -x FZF_DEFAULT_COMMAND 'rg --files --hidden'
    end
end
