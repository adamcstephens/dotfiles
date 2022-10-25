function ls
    if command -q lsd
        lsd $argv
    else
        command ls $argv
    end
end
