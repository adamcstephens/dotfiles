all:
	fresh

ansible:
	ansible-playbook ansible/Darwin.yaml

update-vim:
	vim +PlugUpdate +PlugClean +qall

update-fresh:
	fresh update
	fresh clean

update: update-fresh update-vim

.PHONY: all ansible update-vim update-fresh update
