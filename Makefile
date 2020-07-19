ZSH := $(shell which zsh)

.PHONY: default
default:

.PHONY: clean-fresh
clean-fresh:
	rm -rfv $(HOME)/.fresh $(HOME)/.freshrc $(HOME)/.dotfiles/fresh

.PHONY: install-brew
install-brew:
	/bin/bash -c "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh`"

.PHONY: install-asdf
install-asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.6
	$(HOME)/.asdf/bin/asdf update

.PHONY: install-zsh
install-zsh:
	if ! grep $(ZSH) /etc/shells; then echo "$(ZSH)" | sudo tee -a /etc/shells; fi
	chsh -s $(ZSH)

.PHONY: antibody
antibody:
	antibody bundle < ~/.dotfiles/zsh_plugins.txt > ~/.zsh_plugins.sh

.PHONY: brew
brew:
	brew bundle

.PHONY: brew-dump
brew-dump:
	brew bundle dump --force

.PHONY: terminfo-italic
terminfo-italic:
	PATH="/usr/local/opt/ncurses/bin:$(PATH)" tic -x -o $(HOME)/.terminfo xterm-screen-256color.terminfo
	grep TERM=xterm-screen-256color ~/.shell_local.sh || echo "export TERM=xterm-screen-256color" >> ~/.shell_local.sh

.PHONY: update-asdf
update-asdf:
	if [ -e $(HOME)/.asdf ]; then $(HOME)/.asdf/bin/asdf update; fi
	if [ -e $(HOME)/.asdf/plugins ]; then $(HOME)/.asdf/bin/asdf plugin-update --all; fi

.PHONY: update-vim
update-vim:
	vim +PlugClean +PlugUpdate +qall

.PHONY: clean
clean:
	vim +PlugClean +qall

update: update-asdf update-vim tmuxline

.PHONY: ssh-setup
ssh-setup:
	ssh-keygen -t ed25519

.PHONY: tmuxline
tmuxline:
	if [ ! -z $TMUX ]; then vim +"TmuxlineSnapshot! ~/.tmux.tmuxline" +qall; fi

.PHONY: ubuntu-keyboard
ubuntu-keyboard:
	gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
	gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
	gsettings set org.gnome.desktop.peripherals.keyboard delay 250
	sudo sed -i 's/XKBOPTIONS=""/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

.PHONY: zsh-prof
zsh-prof:
	time zsh -i -c exit

.PHONY: zsh-prof-setup
zsh-prof-setup:
	chmod +w ~/.zshrc
	ex -sc '1i|zmodload zsh/zprof' -cx ~/.zshrc
	echo "zprof" >> ~/.zshrc
