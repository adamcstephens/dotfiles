function diff --wraps=colordiff --description 'alias diff=colordiff'
    if command -q delta
        set differ delta
    else if command -q colordiff
        set differ colordiff
    else
        set differ diff
    end
    command $differ $argv
end
