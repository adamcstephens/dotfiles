function vim
    if command -v emacsclient &>/dev/null
        emacsclient $argv
    end
end
