.PHONY: ansible

all:
	fresh

ansible:
	ansible-playbook ansible/Darwin.yaml
