ZSH := $(shell which zsh)

all:
	fresh

install-brew:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

install-asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.0
	$(HOME)/.asdf/bin/asdf update

install-zsh:
	if ! grep $(ZSH) /etc/shells; then echo "$(ZSH)" | sudo tee -a /etc/shells; fi
	chsh -s $(ZSH)

brew:
	brew bundle

brew-dump:
	brew bundle dump -f
	git diff Brewfile

mac-setup:
	ansible-playbook ansible/Darwin.yaml

mac-upgrade:
	mas upgrade

terminfo-italic:
	tic -o $(HOME)/.terminfo terminfo/tmux-256color.terminfo
	tic -o $(HOME)/.terminfo terminfo/xterm-256color.terminfo

update-asdf:
	if [ -e $(HOME)/.asdf ]; then $(HOME)/.asdf/bin/asdf update; fi
	if [ -e $(HOME)/.asdf/plugins ]; then $(HOME)/.asdf/bin/asdf plugin-update --all; fi

update-vim: all
	vim +PlugClean +PlugUpdate +qall

update-fresh:
	fresh update

update-zplug:
	cd ~/.zplug; git pull
	zsh -i -c zplug clean --force

clean:
	fresh clean
	vim +PlugClean +qall

update: update-asdf update-fresh update-vim update-zplug

linux-workstation:
	ansible-playbook ansible/Linux-workstation.yaml

powerline:
	cd /tmp && \
		git clone https://github.com/powerline/fonts.git --depth=1 && \
		cd fonts && \
		./install.sh && \
		cd .. &&\
		rm -rf fonts

tmuxline:
	vim +"TmuxlineSnapshot ~/.tmux.tmuxline" +qall

zsh-prof:
	time zsh -i -c exit

zsh-prof-setup:
	chmod +w ~/.zshrc
	ex -sc '1i|zmodload zsh/zprof' -cx ~/.zshrc
	echo "zprof" >> ~/.zshrc

.PHONY: all ansible clean update-vim update-fresh update
