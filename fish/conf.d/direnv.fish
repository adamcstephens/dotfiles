if status is-interactive
    if command -v direnv &>/dev/null
        direnv hook fish | source
    end
end
