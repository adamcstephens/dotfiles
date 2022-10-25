if status is-interactive
    if command -v zoxide &>/dev/null
        zoxide init fish --cmd j | source
    end
end
