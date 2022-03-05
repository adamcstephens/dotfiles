# paths
fish_add_path --append ~/bin
fish_add_path --append ~/.dotfiles/bin
fish_add_path --append ~/.local/bin

if test -d ~/.emacs.d/bin
    fish_add_path ~/.emacs.d/bin
end
if test -d ~/go/bin
    fish_add_path ~/go/bin
end
if test -d /snap/bin
    fish_add_path /snap/bin
end
