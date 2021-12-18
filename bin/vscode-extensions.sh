#!/usr/bin/env fish

set extfile ~/.dotfiles/vscode/extensions.txt
set installed (code --list-extensions)
set repo (cat $extfile)

for e in $repo
    if not contains $e $installed
        code --install-extension $e
    end
end

code --list-extensions >$extfile
