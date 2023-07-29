fish_add_path --prepend --move ~/.dotfiles/bin

if ! grep nixos /etc/lsb-release >/dev/null 2>&1
    set -x TERMINFO $HOME/.nix-profile/share/terminfo
end
