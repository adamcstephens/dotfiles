function ivl --wraps='sudo iptables -vnL --line-numbers' --description 'alias ivl=sudo iptables -vnL --line-numbers'
    sudo iptables -vnL --line-numbers $argv
end
