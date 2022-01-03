#!/usr/bin/env fish

set extfile ~/.dotfiles/vscode/extensions.txt

if [ "$argv[1]" = remove ]
    sed -i "/$argv[2]/d" $extfile
    code --uninstall-extension $argv[2]
    exit $status
end

set installed (code --list-extensions)
set repo (cat $extfile)

for e in $repo
    if not contains $e $installed
        code --install-extension $e
    end
end

code --list-extensions >$extfile
