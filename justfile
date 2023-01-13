default:
    just --list

arkenfox-update:
    #!/usr/bin/env bash
    set -e
    version=$(gh release list --repo arkenfox/user.js -L 1 | tail -n 1 | awk '{print $5}')
    git subrepo pull --branch $version apps/firefox/arkenfox/

brew-dump:
    brew bundle dump --all --force
    git diff Brewfile

dotbot config="":
    CONFIG={{config}} ~/.dotfiles/bin/dotbot

doomemacs:
    test -d ~/.config/emacs || mkdir -p ~/.config/emacs
    test -e ~/.config/emacs/doom || git clone https://github.com/doomemacs/doomemacs ~/.config/emacs/doom
    DOOMDIR=~/.config/doom ~/.config/emacs/doom/bin/doom sync
    test -f ~/.config/emacs/doom/.local/env || DOOMDIR=~/.config/doom ~/.config/emacs/doom/bin/doom env

fish-bootstrap:
    fish ~/.dotfiles/bin/theme.fish

intel-check-cstate:
    sudo cat /sys/kernel/debug/pmc_core/package_cstate_show

migrate:
    #!/usr/bin/env bash
    set -e
    if [ -h $HOME/.config/direnv ]; then rm -rfv $HOME/.config/direnv; fi
    if [ -h $HOME/.config/lsd ]; then rm -rfv $HOME/.config/lsd; fi
    if [ -e $HOME/.config/fish/config.fish ] && [ ! -h $HOME/.config/fish/config.fish ]; then rm -v $HOME/.config/fish/config.fish; fi

    if [ -d $HOME/.dotfiles/dotbot ]; then rm -rfv $HOME/.dotfiles/dotbot; fi
    if [ -f $HOME/.dotfiles/fish/fish_variables ]; then mv -v $HOME/.dotfiles/fish/fish_variables $HOME/.dotfiles/apps/fish/; fi
    if [ -d $HOME/.dotfiles/fish ]; then rm -rfv $HOME/.dotfiles/fish; fi
    if [ -d $HOME/.dotfiles/btop ]; then rm -rfv $HOME/.dotfiles/btop; fi

    if rg lefthook ~/.dotfiles/.git/hooks &>/dev/null; then nix run nixpkgs#lefthook -- uninstall; fi;
    if [ "$(readlink $HOME/.config/kitty/kitty.conf)" == "$HOME/.dotfiles/apps/kitty/kitty.conf" ]; then rm -v $HOME/.config/kitty/kitty.conf; fi
    if [ "$(readlink $HOME/.config/kitty/theme-dark.conf)" == "$HOME/.dotfiles/apps/kitty/theme-dark.conf" ]; then rm -v $HOME/.config/kitty/theme-dark.conf; fi

    if [ "$(readlink $HOME/.config/waybar/style.css)" == "$HOME/.dotfiles/apps/waybar/waybar.css" ]; then rm -v $HOME/.config/waybar/style.css; fi

nix-index-fetch:
    #!/usr/bin/env bash
    set -e
    filename="index-x86_64-$(uname | tr A-Z a-z)"
    mkdir -p ~/.cache/nix-index
    cd ~/.cache/nix-index
    wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
    ln -f $filename files

nix-upgrade:
    sudo nix-channel --update
    sudo nix-env -iA nixpkgs.nix nixpkgs.cacert
    sudo systemctl daemon-reload
    sudo systemctl restart nix-daemon

ssh-keygen:
    ssh-keygen -t ed25519

steam-bootstrap:
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub com.valvesoftware.Steam

vim-plugins:
    git subrepo clone https://github.com/airblade/vim-gitgutter apps/vim/vim/pack/plugins/start/vim-gitgutter
    git subrepo clone https://github.com/airblade/vim-rooter apps/vim/vim/pack/plugins/start/vim-rooter
    git subrepo clone https://github.com/ConradIrwin/vim-bracketed-paste apps/vim/vim/pack/plugins/start/bracketed-paste
    git subrepo clone https://github.com/godlygeek/tabular apps/vim/vim/pack/plugins/start/tabular
    git subrepo clone https://github.com/itchyny/lightline.vim apps/vim/vim/pack/plugins/start/lightline.vim
    git subrepo clone https://github.com/j-tom/vim-old-hope apps/vim/vim/pack/plugins/start/old-hope
    git subrepo clone https://github.com/junegunn/fzf.vim apps/vim/vim/pack/plugins/start/fzf.vim
    git subrepo clone https://github.com/sheerun/vim-polyglot apps/vim/vim/pack/plugins/start/vim-polyglot
    git subrepo clone https://github.com/tpope/vim-commentary apps/vim/vim/pack/plugins/start/vim-commentary
    git subrepo clone https://github.com/tpope/vim-repeat apps/vim/vim/pack/plugins/start/vim-repeat
    git subrepo clone https://github.com/tpope/vim-surround apps/vim/vim/pack/plugins/start/vim-surround
    git subrepo clone https://github.com/tpope/vim-unimpaired apps/vim/vim/pack/plugins/start/vim-unimpaired
