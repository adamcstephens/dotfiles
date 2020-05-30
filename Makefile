ZSH := $(shell which zsh)

default:

install-brew:
	/bin/bash -c "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh`"

install-asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.6
	$(HOME)/.asdf/bin/asdf update

install-zsh:
	if ! grep $(ZSH) /etc/shells; then echo "$(ZSH)" | sudo tee -a /etc/shells; fi
	chsh -s $(ZSH)

antibody:
	antibody bundle < ~/.dotfiles/zsh_plugins.txt > ~/.zsh_plugins.sh

aptfile:
	sudo $(HOME)/bin/aptfile

aptfile-desktop:
	sudo $(HOME)/bin/aptfile $(HOME)/.dotfiles/aptfile.desktop

brew:
	brew bundle

brew-dump:
	brew bundle dump --force

terminfo-italic:
	PATH="/usr/local/opt/ncurses/bin:$(PATH)" tic -x -o $(HOME)/.terminfo xterm-screen-256color.terminfo
	grep TERM=xterm-screen-256color ~/.shell_local.sh || echo "export TERM=xterm-screen-256color" >> ~/.shell_local.sh

update-asdf:
	if [ -e $(HOME)/.asdf ]; then $(HOME)/.asdf/bin/asdf update; fi
	if [ -e $(HOME)/.asdf/plugins ]; then $(HOME)/.asdf/bin/asdf plugin-update --all; fi

update-vim:
	vim +PlugClean +PlugUpdate +qall

clean:
	vim +PlugClean +qall

update: update-asdf update-vim tmuxline

ssh-setup:
	ssh-keygen -t ed25519

tmuxline:
	if [ ! -z $TMUX ]; then vim +"TmuxlineSnapshot! ~/.tmux.tmuxline" +qall; fi

ubuntu-keyboard:
	gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
	gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
	gsettings set org.gnome.desktop.peripherals.keyboard delay 250
	sudo sed -i 's/XKBOPTIONS=""/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

zsh-prof:
	time zsh -i -c exit

zsh-prof-setup:
	chmod +w ~/.zshrc
	ex -sc '1i|zmodload zsh/zprof' -cx ~/.zshrc
	echo "zprof" >> ~/.zshrc

.PHONY: default antibody aptfile-desktop aptfile brew-dump brew clean install-asdf install-brew install-zsh ssh-setup terminfo-italic tmuxline ubuntu-keyboard update-asdf update-vim update zsh-prof-setup zsh-prof
