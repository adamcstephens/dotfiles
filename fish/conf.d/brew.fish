if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)

    if test -d /opt/homebrew/opt/node@16/bin
        fish_add_path --prepend /opt/homebrew/opt/node@16/bin
    end

    if test -d /opt/homebrew/opt/python@3.10/bin
        fish_add_path --prepend /opt/homebrew/opt/python@3.10/bin
    end
end
