all:
	fresh

brew:
	brew bundle

brew-dump:
	brew bundle dump -f
	git diff Brewfile

asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.0
	$(HOME)/.asdf/bin/asdf update

dev-ruby:
	ansible-playbook ansible/dev-ruby.yaml

dev-python-pyenv:
	git clone https://github.com/yyuu/pyenv.git ~/.pyenv

dev-ruby-rbenv:
	git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

mac-setup:
	ansible-playbook ansible/Darwin.yaml

mac-upgrade:
	mas upgrade

terminfo-italic:
	tic -o $(HOME)/.terminfo terminfo/tmux-256color.terminfo
	tic -o $(HOME)/.terminfo terminfo/xterm-256color.terminfo

update-asdf:
	asdf update
	asdf plugin-update --all

update-vim: all
	vim +PlugClean +PlugUpdate +qall

update-fresh:
	fresh update

update-zplug:
	pushd ~/.zplug; git pull; popd

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

zsh-prof:
	time zsh -i -c exit

zsh-prof-setup:
	chmod +w ~/.zshrc
	ex -sc '1i|zmodload zsh/zprof' -cx ~/.zshrc
	echo "zprof" >> ~/.zshrc

.PHONY: all ansible clean update-vim update-fresh update
