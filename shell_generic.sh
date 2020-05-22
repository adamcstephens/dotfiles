# shellcheck shell=bash

# shellcheck disable=SC1090
[[ -e "$HOME/.shell_local.sh" ]] && . "$HOME/.shell_local.sh"
export PATH=~/bin:$PATH:/snap/bin

alias thisweek='date +%Y-%W'

export PAGER='less -rFX'

# ls
alias ll="ls -l"
alias l="ls -la"
alias l1h="ls -1t | head"
alias scat="egrep -v '^(\s*)?(#|$)' "
# colorize ls output
export CLICOLOR=''
if ls --color=auto > /dev/null 2>&1
then
  alias ls="ls --color=auto"
fi

# shell
# shellcheck disable=SC2139
alias esl="exec $SHELL -l"

# notes
alias cln="cat ~/notes/\`ls -1t ~/notes | head -n1\`"
alias eln="vim ~/notes/\`ls -1t ~/notes | head -n1\`"
alias nn="vim ~/notes/\`date +%Y-%m-%d_%H%M\`.md"
alias lnn="ls -lt ~/notes"
alias lln="ls -1 ~/notes/\`ls -1t ~/notes | head -n1\`"

elng() {
  filename=$(grep -H "$1" ~/notes/* | cut -f1 -d: | sort -u | head -n1)
  if [ -e "$filename" ]
  then
    vim "$filename"
  else
    echo "no note found"
  fi
}

# passwords
if command -v apg > /dev/null; then
  alias pwgen='apg -n10 -m12 -x20 -M CLNS -t'
elif command -v pwgen > /dev/null; then
  alias pwgen='pwgen -cn1 20 12'
fi

shell_os() {
  dotfiles_shell_os_path="shell/os"
  shell_os_path="$HOME/.dotfiles/${dotfiles_shell_os_path}"
  shell="$1"
  OS=$(uname)

  if [[ "$OS" == 'Linux' ]]; then
    if [[ -e /etc/arch-release ]]; then
      DIST='arch'
    elif [[ -e /etc/debian_version ]]; then
      DIST='debian'
    elif [[ -e /etc/fedora-release ]]; then
      DIST='fedora'
    elif [[ -e /etc/redhat-release ]]; then
      DIST='redhat'
    fi
  else
    DIST="$OS"
  fi

  if [[ -e "${shell_os_path}/${OS}.sh" ]]; then
    source "${shell_os_path}/${OS}.sh"
  fi

  if [[ -e "${shell_os_path}/${OS}.${shell}" ]]; then
    source "${shell_os_path}/${OS}.${shell}"
  fi

  if [[ "$OS" == 'Linux' ]] && [[ -e "${shell_os_path}/Linux/${DIST}.sh" ]]; then
    source "${shell_os_path}/Linux/${DIST}.sh"
  fi
}
# shellcheck disable=SC2086
shell_os "$(basename $SHELL)"

#
# app specific
#

# ag
alias ag="ag --no-break --no-heading --color-match '1;32' --color-path '0;34'"

# ansible
alias ap='ansible-playbook '
alias ac='ansible-container '

# bat, since debian named it batcat
alias bat='batcat '

# bundle
alias be='bundle exec '

# colordiff
if command -v colordiff > /dev/null; then
  alias diff=colordiff
fi

# direnv
alias da="direnv allow"

# docker
alias dc="docker-compose "
alias dcgc="docker run -ti -v /var/run/docker.sock:/var/run/docker.sock yelp/docker-custodian dcgc "
alias dclf="docker-compose logs --tail=100 -f"
alias di='docker images '
alias dk='docker kill '
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}"'
alias drm='docker rm '
alias drmi='docker rmi '
dsh() {
  [ -z "$1" ] && echo "needs image to run." && return 2
  runimg="$1"
  shift
  if [ -z "$1" ]
  then
    runcmd="/bin/bash"
  else
    runcmd="$*"
  fi
  # shellcheck disable=SC2086
  docker run -t -i --rm=true $runimg $runcmd
}

# git
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
  [ -z "$1" ] && git log --oneline -n 10 && return 0
  # shellcheck disable=SC2068
  git log --oneline $@
}
alias gm='git merge'
alias gp='git push'
alias gpob="git push -u origin \$(git rev-parse --abbrev-ref HEAD)"
alias gppr="gpob && hub pull-request"
alias gpt='git push && git push --tags'
alias grh='git reset HEAD'
alias grv='git remote -v'
alias gs='git status'
alias gss='git status --short'
gt () {
  [ -z "$1" ] && git tag -l -n1 && return 0
  # shellcheck disable=SC2068
  git tag $@
}

# gpg
if [[ -d ~/.gnupg/private-keys-v1.d && $(find ~/.gnupg/private-keys-v1.d | wc -l) -gt 1 ]]
then
  # shellcheck disable=SC2046
  pgrep gpg-agent &>/dev/null || eval $(gpg-agent --daemon)
fi
if [[ -e "/run/user" ]] ; then
  [[ -e "$(gpgconf --list-dirs agent-socket)" ]] || gpgconf --create-socketdir
fi

# grep
export GREP_COLOR='3;32'
alias grep='grep --color=auto'

# gsed
if command -v gsed > /dev/null; then
  alias sed=gsed
fi

# snap
if command -v snap > /dev/null; then
  export PATH=$PATH:/snap/bin
fi

# ssh
alias ssh="TERM=xterm-256color ssh"
delkey() {
  [[ -z $1 ]] && echo "supply deletion key" && return 2
  delip="$(grep "${1}"\  "$HOME"/.ssh/known_hosts | awk '{print $1}' | cut -f 2 -d \, )"

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
  local socket_path

  if ! [[ "$socket_path" ]]; then
    echo 'no socket path' >&2
    return 1
  else
    export SSH_AUTH_SOCK="$socket_path"
  fi
}
alias uas=update_auth_sock
tm() {
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