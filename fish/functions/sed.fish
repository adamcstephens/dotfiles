function sed
    if command -v gsed &>/dev/null
        gsed $argv
    else
        command sed $argv
    end
end
