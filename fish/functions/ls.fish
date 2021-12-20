function ls
    if command -q exa
        exa $argv
    else
        command ls $argv
    end
end
