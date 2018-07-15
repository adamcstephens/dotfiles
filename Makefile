all:
	fresh

dev-ruby:
	ansible-playbook ansible/dev-ruby.yaml

dev-python-pyenv:
	git clone https://github.com/yyuu/pyenv.git ~/.pyenv

dev-ruby-rbenv:
	git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

mac:
	ansible-playbook ansible/Darwin.yaml

update-vim: all
	vim +PlugUpdate +qall

update-fresh:
	fresh update

clean:
	fresh clean
	vim +PlugClean +qall

update: update-fresh update-vim

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
	chmod +w ~/.zshrc
	ex -sc '1i|zmodload zsh/zprof' -cx ~/.zshrc
	echo "zprof" >> ~/.zshrc

.PHONY: all ansible clean update-vim update-fresh update
