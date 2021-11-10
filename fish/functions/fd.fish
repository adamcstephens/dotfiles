function fd
    if command -v fdfind &>/dev/null
        fdfind $argv
    else
        command fd $argv
    end
end
