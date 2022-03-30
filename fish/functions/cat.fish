function cat
    if command -q batcat
        batcat $argv
    else if command -q bat
        bat $argv
    else
        command cat $argv
    end
end
