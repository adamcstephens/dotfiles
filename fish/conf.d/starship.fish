if status is-interactive
    if command -q starship
        starship init fish | source
    end
end
