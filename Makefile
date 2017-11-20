.PHONY: ansible

all:
	fresh

ansible:
	ansible-playbook ansible/Darwin.yaml

update-vim:
	vim +PlugUpdate +PlugClean
