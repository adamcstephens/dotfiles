# paths
if test -d ~/.emacs.d/bin
    fish_add_path --prepend --move ~/.emacs.d/bin
end
if test -d ~/go/bin
    fish_add_path --prepend --move ~/go/bin
end
if test -d /snap/bin
    fish_add_path --prepend --move /snap/bin
end

fish_add_path --prepend --move ~/.local/bin
fish_add_path --prepend --move ~/bin
fish_add_path --prepend --move ~/.dotfiles/bin
