function fd
    if command -v fdfind &>/dev/null
        fdfind $argv
    else
        fd $argv
    end
end
