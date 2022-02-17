#!/usr/bin/env fish

set extfile ~/.dotfiles/vscode/extensions.txt
set uninstfile ~/.dotfiles/vscode/extensions-uninstall.txt

if [ "$argv[1]" = install ]
    sed -i "/$argv[2]/d" $uninstfile
    code --install-extension $argv[2]
else if [ "$argv[1]" = remove ]
    sed -i "/$argv[2]/d" $extfile
    code --uninstall-extension $argv[2]
    echo $argv[2] >>$uninstfile
    exit $status
end

set installed (code --list-extensions)
set repo (cat $extfile)
set uninstall (cat $uninstfile)

for u in $uninstall
    if contains $u $installed
        code --uninstall-extension $u
    end
end

for e in $repo
    if not contains $e $installed
        code --install-extension $e
    end
end

code --list-extensions >$extfile
