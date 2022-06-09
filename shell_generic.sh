# shellcheck shell=bash disable=SC1091

if [[ -e ~/.terminfo/78/xterm-screen-256color ]]; then
  export TERM=xterm-screen-256color
fi

# shellcheck disable=SC1090
[[ -e "$HOME/.shell_local.sh" ]] && . "$HOME/.shell_local.sh"
export PATH=~/go/bin:~/.local/share/aquaproj-aqua/bin:~/.dotfiles/bin:~/bin:~/.local/bin:$PATH
export AQUA_GLOBAL_CONFIG=~/.config/aquaproj-aqua/aqua.yaml

alias thisweek='date +%Y-%W'

export PAGER='less'
export EDITOR="$HOME/bin/editor"

# ls
alias ll="ls -l"
alias l="ls -la"
alias l1h="ls -1t | head"
alias scat="egrep -v '^(\s*)?(#|$)' "
# colorize ls output
export CLICOLOR=''
if ls --color=auto >/dev/null 2>&1; then
  alias ls="ls --color=auto"
fi

# shell
# shellcheck disable=SC2139
alias esl="exec $SHELL -l"

# custom terminal overrides
if [[ "$TERM" == "xterm-screen-256color" ]]; then
  NEWTERM="xterm-256color"
  alias lxc='TERM=$NEWTERM lxc'
  alias multipass='TERM=$NEWTERM multipass'
  alias ssh='TERM=$NEWTERM ssh'
  export TERMINFO=$HOME/.terminfo
elif [[ "$TERM" == "xterm-kitty" ]]; then
  alias ssh="kitty +kitten ssh"
  export TERMINFO=$HOME/.terminfo
fi

license() {
  wget -O LICENSE https://www.gnu.org/licenses/agpl-3.0.txt
}

# passwords
if command -v pwgen >/dev/null; then
  alias pwgen='pwgen -csn1 20 12'
fi

toggle_dark() {
  [[ -z $1 ]] && return 1

  if [[ -n $KITTY_WINDOW_ID && "$TERM_PROGRAM" != "vscode" ]]; then
    if [[ $1 == "off" ]]; then
      kitty @ set-colors --all --configured ~/.config/kitty/theme-light.conf
    else
      kitty @ set-colors --reset
    fi
  fi
}

if [ -d /run/WSL ]; then
  # shellcheck disable=SC1090
  . ~/bin/wsl-ssh-relay
  ~/bin/wsl-gpg-relay
fi

#
# app specific
#

# ansible
alias ad='ansible-doc '
alias ap='ansible-playbook '
alias ac='ansible-container '

# asdf
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE=$HOME/.dotfiles/python-packages
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"

# bundle
alias be='bundle exec '

# colordiff
if command -v colordiff >/dev/null; then
  alias diff=colordiff
fi

# direnv
if command -v direnv &>/dev/null; then
  alias da="direnv allow"
fi

# docker
alias dc="docker-compose "
alias dcgc="docker run -ti -v /var/run/docker.sock:/var/run/docker.sock yelp/docker-custodian dcgc "
alias dclf="docker-compose logs --tail=100 -f"
alias di='docker images '
alias dk='docker kill '
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}"'
alias drm='docker rm '
alias drmi='docker rmi '
dive() {
  # shellcheck disable=SC2068
  docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest $@
}
dsh() {
  [ -z "$1" ] && echo "needs image to run." && return 2
  runimg="$1"
  shift
  if [ -z "$1" ]; then
    runcmd="/bin/bash"
  else
    runcmd="$*"
  fi
  # shellcheck disable=SC2086
  docker run -t -i --rm=true $runimg $runcmd
}
dcnet() {
  [[ -z $1 ]] && return 1
  svc=$(docker-compose ps | grep "$1" | awk '{print $1}')
  [[ -z $svc ]] && return 1

  docker run -it --net container:"$svc" nicolaka/netshoot
}

# emacs
if [ -d ~/.emacs.d/bin ]; then
  export PATH="$PATH:$HOME/.emacs.d/bin"
fi

# fd
if command -v fdfind &>/dev/null; then
  alias fd=fdfind
fi

# git
[[ -e "$HOME"/.dotfiles/git-subrepo/.rc ]] && source "$HOME"/.dotfiles/git-subrepo/.rc
alias ga='git add'
gac() {
  [ -z "$1" ] && echo "needs argument" && return 20
  # shellcheck disable=SC2068
  git add $@ && git commit -v
}
alias gbv='git branch -avv'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gdt="git diff \$(git describe --tags \$(git rev-list --tags --max-count=1 2>/dev/null ))..HEAD"
alias gl='git pull'
glo() {
  [ -z "$1" ] && git log --graph --decorate --pretty=oneline --abbrev-commit --max-count=15 && return 0
  # shellcheck disable=SC2068
  git log --oneline $@
}
alias gm='git merge'
alias gp='git push'
alias gpob="git push -u origin \$(git rev-parse --abbrev-ref HEAD):\$(git rev-parse --abbrev-ref HEAD)"
alias gppr="gpob && hub pull-request"
alias gpt='git push && git push --tags'
alias grh='git reset HEAD'
alias grv='git remote -v'
alias gs='git status'
alias gss='git status --short'
gt() {
  [ -z "$1" ] && git tag -l -n1 && return 0
  # shellcheck disable=SC2068
  git tag $@
}
gitignore() {
  [ -z "$1" ] && echo "missing language to ignore" && return 1

  if wget --output-document=.gitignore.tmp "https://raw.githubusercontent.com/github/gitignore/master/$1.gitignore"; then
    if [ -e .gitignore ]; then
      cat .gitignore.tmp >>.gitignore
    else
      mv -v .gitignore.tmp .gitignore
    fi
  fi

  rm -f .gitignore.tmp
}

# gnome-keyring-daemon
if command -v gnome-keyring-daemon &>/dev/null; then
  if [ -n "$DESKTOP_SESSION" ]; then
    eval "$(gnome-keyring-daemon --start --components=secrets,pkcs11)"
  fi
fi

# gpg
if command -v gpgconf >/dev/null && [[ -n "$XDG_RUNTIME_DIR" && -d "$XDG_RUNTIME_DIR" ]]; then
  [ -e "$(gpgconf --list-dirs agent-socket)" ] || gpgconf --create-socketdir
fi
gpgfwd() {
  host=$1
  scp ~/.gnupg/pubring.kbx "$host":.gnupg/
  scp ~/.gnupg/trustdb.gpg "$host":.gnupg/
}

# grep
export GREP_COLOR='3;32'
alias grep='grep --color=auto'

# gsed
if command -v gsed >/dev/null; then
  alias sed=gsed
fi

# iproute2
alias ip='ip --color'

# iptables
alias ivl='sudo iptables -vnL --line-numbers'

# kubectl
alias k="kubectl "
alias kns="kubens "

# nix
if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME"/.nix-profile/etc/profile.d/hm-session-vars.sh
fi
if [ -e "$HOME/.nix-defexpr/channels" ]; then
  export NIX_PATH="$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH"
fi

# python
export PYTHONSTARTUP="$HOME"/.dotfiles/pythonstartup.py

# ripgrep
export RIPGREP_CONFIG_PATH="$HOME"/.config/ripgrep/ripgreprc
if command -v rg >/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
fi

# rust
if [ -d "${HOME}/.cargo/bin" ]; then
  export PATH="${HOME}/.cargo/bin:$PATH"
fi

# snap
if command -v snap >/dev/null; then
  export PATH=$PATH:/snap/bin
fi

# ssh
if [[ -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi
if [[ -n $SSH_AUTH_SOCK ]] && ! ssh-add -l &>/dev/null; then
  echo "Empty ssh-agent"
fi
delkey() {
  [[ -z $1 ]] && echo "supply deletion key" && return 2
  delip="$(grep "${1}"\  "$HOME"/.ssh/known_hosts | awk '{print $1}' | cut -f 2 -d \,)"

  [[ -n $delip ]] && ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$delip"
  ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$1"
}

# terraform
alias tp='terraform plan '
alias tp='terraform plan '
alias ta='terraform apply '
alias taa='terraform apply -auto-approve '

# tree
alias tree='tree -FC'
tfind() {
  findfile=$1
  shift
  # shellcheck disable=SC2068
  tree --prune -P "*$findfile*" $@
}

# tmux
update_auth_sock() {
  socket_path="$(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')"

  if ! [ -e "$socket_path" ]; then
    echo 'no socket path' >&2
    return 1
  else
    export SSH_AUTH_SOCK="$socket_path"
  fi
}
alias uas=update_auth_sock
tm() {
  # shellcheck disable=SC2164
  cd ~
  tmux attach-session || tmux new-session
}
# copy this as an alternative future option
# if [ -n "$TMUX" ]; then
#   TMUX_SESSION=`tmux display-message -p '#S'`
#   SOCK="$HOME/.ssh/.ssh-agent-$USER-tmux-$TMUX_SESSION"
#   if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]; then
#     rm -f $SOCK
#     ln -sf $SSH_AUTH_SOCK $SOCK
#     export SSH_AUTH_SOCK=$SOCK
#   fi
# fi

# vagrant
alias vdestroy='vagrant destroy '
alias vp='vagrant provision '
alias vpp='vp --provision-with puppet '
alias vpps='vp --provision-with puppet_server '
alias vs='vagrant status '
alias vsg='vagrant global-status '
alias vup='vagrant up '
alias vssh='vagrant ssh '
vreload() {
  vmName="$1"
  vagrant destroy -f "$vmName"
  vup "$2" "$vmName"
  vssh "$vmName"
}

# virtualbox
alias vb=VBoxManage

# vscode
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  alias vim=code
  if [[ $TERM_PROGRAM_VERSION == *-insider ]]; then
    alias code=code-insiders
  fi
fi
