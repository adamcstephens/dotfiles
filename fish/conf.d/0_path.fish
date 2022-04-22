# paths
if test -d ~/.emacs.d/bin
    fish_add_path --prepend --move ~/.emacs.d/bin
end
if test -d ~/go/bin
    fish_add_path --prepend --move ~/go/bin
    set -x GOPATH ~/go
    set -x GOBIN ~/go/bin
end
if test -d /snap/bin
    fish_add_path --prepend --move /snap/bin
end
if test -d ~/.cabal/bin
    fish_add_path --prepend --move ~/.cabal/bin
end
if test -d ~/.ghcup/bin
    fish_add_path --prepend --move ~/.ghcup/bin
end
if test -d ~/.local/share/aquaproj-aqua/bin
    fish_add_path ~/.local/share/aquaproj-aqua/bin
end


fish_add_path --prepend --move ~/.local/bin
fish_add_path --prepend --move ~/bin
fish_add_path --prepend --move ~/.dotfiles/bin
