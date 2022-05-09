function ad --wraps='ansible-doc ' --wraps=ansible-doc --description 'alias ad=ansible-doc'
    if [ -z $argv[1] ]
        ansible-doc (ansible-doc -l 2>/dev/null | fzf --no-hscroll | awk '{print $1}')
    else
        ansible-doc $argv
    end
end
