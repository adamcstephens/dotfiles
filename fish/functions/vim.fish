function vim
    if command -q emacsclient
        emacsclient $argv
    else
        command vim $argv
    end
end
