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

    removeDotbotConfig() {
      file=$1
      if [ "$(readlink $HOME/.config/$file)" == "$HOME/.dotfiles/apps/$file" ]; then rm -v $HOME/.config/$file; fi
    }

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
    if [ "$(readlink $HOME/.config/starship.toml)" == "$HOME/.dotfiles/apps/starship/starship.toml" ]; then rm -v $HOME/.config/starship.toml; fi

    if [ "$(readlink $HOME/.shell_generic.sh)" == "$HOME/.dotfiles/apps/shell_generic.sh" ]; then rm -v $HOME/.shell_generic.sh; fi
    if [ "$(readlink $HOME/.zshrc)" == "$HOME/.dotfiles/apps/zsh/zshrc" ]; then rm -v $HOME/.zshrc; fi
    if [ "$(readlink $HOME/.bashrc)" == "$HOME/.dotfiles/apps/bash/bashrc" ]; then rm -v $HOME/.bashrc; fi
    if [ "$(readlink $HOME/.bash_profile)" == "$HOME/.dotfiles/apps/bash/bash_profile" ]; then rm -v $HOME/.bash_profile; fi
    if [ "$(readlink $HOME/.inputrc)" == "$HOME/.dotfiles/apps/inputrc" ]; then rm -v $HOME/.inputrc; fi
    if [ "$(readlink $HOME/.screenrc)" == "$HOME/.dotfiles/apps/screen/screenrc" ]; then rm -v $HOME/.screenrc; fi
    if [ "$(readlink $HOME/.toprc)" == "$HOME/.dotfiles/apps/top/toprc" ]; then rm -v $HOME/.toprc; fi
    if [ "$(readlink $HOME/.editorconfig)" == "$HOME/.dotfiles/apps/editorconfig/editorconfig" ]; then rm -v $HOME/.editorconfig; fi
    if [ "$(readlink $HOME/.aspell.en.pws)" == "$HOME/.dotfiles/apps/aspell/aspell.en.pws" ]; then rm -v $HOME/.aspell.en.pws; fi
    if [ "$(readlink $HOME/.shellcheckrc)" == "$HOME/.dotfiles/apps/shellcheck/shellcheckrc" ]; then rm -v $HOME/.shellcheckrc; fi
    if [ "$(readlink $HOME/.gitignore)" == "$HOME/.dotfiles/apps/git/gitignore" ]; then rm -v $HOME/.gitignore; fi
    if [ "$(readlink $HOME/.gitconfig)" == "$HOME/.dotfiles/apps/git/gitconfig" ]; then rm -v $HOME/.gitconfig; fi
    if [ "$(readlink $HOME/.vim)" == "$HOME/.dotfiles/apps/vim/vim" ]; then rm -rfv $HOME/.vim; fi
    if [ "$(readlink $HOME/.vimrc)" == "$HOME/.dotfiles/apps/vim/vimrc" ]; then rm -v $HOME/.vimrc; fi
    if [ "$(readlink $HOME/.tzvt_config)" == "$HOME/.dotfiles/apps/tmux/tzvt_config" ]; then rm -v $HOME/.tzvt_config; fi
    if [ "$(readlink $HOME/.tmux.conf)" == "$HOME/.dotfiles/apps/tmux/tmux.conf" ]; then rm -v $HOME/.tmux.conf; fi
    if [ -d "$HOME/.ipython" ]; then rm -rfv $HOME/.ipython; fi
    if [ -d "$HOME/.tmux" ]; then rm -rfv $HOME/.tmux; fi
    if [ ! -h "$HOME/.profile" ]; then rm -fv $HOME/.profile; fi


    removeDotbotConfig bat/config
    removeDotbotConfig btop
    removeDotbotConfig yay
    removeDotbotConfig zellij
    removeDotbotConfig ripgrep
    removeDotbotConfig git/template
    removeDotbotConfig fish

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
