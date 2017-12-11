all:
	fresh

mac:
	ansible-playbook ansible/Darwin.yaml

update-vim:
	vim +PlugUpdate +PlugClean +qall

update-fresh:
	fresh update
	fresh clean

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

.PHONY: all ansible update-vim update-fresh update
