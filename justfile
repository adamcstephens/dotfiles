default:
    just --list

aqua-run:
    cd ./aqua; aqua install

bootstrap-nonix: aqua-run dotbot fish-bootstrap

brew-dump:
    brew bundle dump --all --force
    git diff Brewfile

dotbot config="":
    CONFIG={{config}} ~/.dotfiles/bin/dotbot

doomemacs:
    test -e ~/.emacs.d || git clone https://github.com/doomemacs/doomemacs ~/.emacs.d
    ~/.emacs.d/bin/doom sync
    test -f ~/.emacs.d/.local/env || doom env

fish-bootstrap:
    fish ~/.dotfiles/bin/theme.fish

migrate:
    #!/usr/bin/env bash
    set -e
    if [ -h $HOME/.config/direnv ]; then rm -rfv $HOME/.config/direnv; fi
    if [ -e $HOME/.config/fish/config.fish ] && [ ! -h $HOME/.config/fish/config.fish ]; then rm -v $HOME/.config/fish/config.fish; fi

    if [ -d $HOME/.dotfiles/dotbot ]; then rm -rfv $HOME/.dotfiles/dotbot; fi
    if [ -f $HOME/.dotfiles/fish/fish_variables ]; then mv -v $HOME/.dotfiles/fish/fish_variables $HOME/.dotfiles/apps/fish/; fi
    if [ -d $HOME/.dotfiles/fish ]; then rm -rfv $HOME/.dotfiles/fish; fi
    if [ -d $HOME/.dotfiles/btop ]; then rm -rfv $HOME/.dotfiles/btop; fi

    if rg lefthook ~/.dotfiles/.git/hooks &>/dev/null; then nix run nixpkgs#lefthook -- uninstall; fi;

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
