function fd
    set fdopts --ignore-case --hidden --follow
    if command -v fdfind &>/dev/null
        fdfind $fdopts $argv
    else
        command fd $fdopts $argv
    end
end
