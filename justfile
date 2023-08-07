default:
    just --list

brew-dump:
    brew bundle dump --all --force
    git diff Brewfile

bump:
    nix flake update --commit-lock-file
    nix run .#hm-all
    git push

fish-bootstrap:
    fish ~/.dotfiles/bin/theme.fish

git-config email:
    git config -f ~/.gitconfig.local user.email {{ email }}

intel-check-cstate:
    sudo cat /sys/kernel/debug/pmc_core/package_cstate_show

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

test:
    nix build --print-build-logs --keep-going .#homeConfigurations.aarch64-darwin.activationPackage .#homeConfigurations.aarch64-linux.activationPackage .#homeConfigurations.think.activationPackage

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
