.PHONY: default
default:

.PHONY: backup-windows-terminal
backup-windows-terminal:
	cp /mnt/c/Users/adam/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_*/LocalState/settings.json ./windowsterminal-settings.json
	chmod 644 windowsterminal-settings.json

.PHONY: install-brew
install-brew:
	~/.dotfiles/bin/install-brew.sh

.PHONY: install-asdf
install-asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
	$(HOME)/.asdf/bin/asdf update

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

.PHONY: install-starship
install-starship:
	~/.dotfiles/bin/install-starship.sh --bin-dir ~/bin --yes

.PHONY: install-zoxide
install-zoxide:
	~/.dotfiles/bin/install-zoxide.sh

.PHONY: update-bins
update-bins: install-starship install-zoxide

update: update-asdf update-vim update-bins

.PHONY: ssh-setup
ssh-setup:
	ssh-keygen -t ed25519

.PHONY: tmuxline
tmuxline:
	if [ ! -z $TMUX ]; then vim +"TmuxlineSnapshot! ~/.tmux.tmuxline" +qall; fi

.PHONY: zsh-prof
zsh-prof:
	time zsh -i -c exit

.PHONY: zsh-prof-setup
zsh-prof-setup:
	chmod +w ~/.zshrc
	ex -sc '1i|zmodload zsh/zprof' -cx ~/.zshrc
	echo "zprof" >> ~/.zshrc
