all:
	fresh

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

.PHONY: all ansible clean update-vim update-fresh update
