# shellcheck shell=bash

# shellcheck disable=SC1090
[[ -e "$HOME/.shell_local.sh" ]] && . "$HOME/.shell_local.sh"
export PATH=~/.dotfiles/bin:~/bin:~/.local/bin:$PATH:/snap/bin:~/go/bin

alias thisweek='date +%Y-%W'

export PAGER='less -r'
export EDITOR="$HOME/bin/editor"

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

# custom terminal overrides
if [[ "$TERM" == "xterm-screen-256color" ]]; then
  NEWTERM="xterm-256color"
  alias lxc="TERM=$NEWTERM lxc"
  alias multipass="TERM=$NEWTERM multipass"
  alias ssh="TERM=$NEWTERM ssh"
  export TERMINFO=$HOME/.terminfo
elif [[ "$TERM" == "xterm-kitty" ]]; then
  alias ssh="kitty +kitten ssh"
  export TERMINFO=$HOME/.terminfo
fi

# notes

edit_note() {
  date=$(date +%Y-%m-%d_%H%M)

  if [[ -n $1 ]]; then
    notename="$1"
    if echo "$1" | grep -q "$HOME/notes"; then
      filename="$1"
    else
      filename="${HOME}/notes/${1}.md"
    fi
  else
    notename="$PWD"
    filename="${HOME}/notes/${date}.md"
  fi

  if [[ ! -f "$filename" ]]; then
    echo "# ${date} - ${notename}" >> "$filename"
  fi

  if [[ "$TERM_PROGRAM" == "vscode" ]]
  then
    code "$filename"
  else
    vim "$filename"
  fi
}
find_note() {
  note="$(rg "$1" ~/notes | fzf)"
  [[ -n "$note" ]] && edit_note "${note/:*/}"
}
alias cln="cat ~/notes/\`ls -1t ~/notes | head -n1\`"
alias eln="edit_note \`ls -1t ~/notes | head -n1\`"
alias fn="find_note "
alias nn="edit_note"
alias lnn="ls -lt ~/notes"
alias lln="ls -1 ~/notes/\`ls -1t ~/notes | head -n1\`"


license() {
  wget -O LICENSE https://www.gnu.org/licenses/agpl-3.0.txt
}

# passwords
if command -v apg > /dev/null; then
  alias pwgen='apg -n10 -m12 -x20 -M CLNS -t'
elif command -v pwgen > /dev/null; then
  alias pwgen='pwgen -csn1 20 12'
fi
newpassgen() {
  for z in {1..10}
  do
    n=$(wc -l /usr/share/dict/words)
    for x in {1..3}
    do
      y="$(cat -n /usr/share/dict/words | grep -w "$(jot -r 1 1 "$n")" | cut -f2)"
      echo -n "$y "
      if [[ "$x" == '2' ]]
      then
        y="$(od -vAn -N1 -tu < /dev/urandom | head -n 1 | awk '{print $1}')"
        z="$(pwgen -0yA -r abcdefghijklmnopqrstuvwxyz 1 1)"
        echo -n "$y$z "
      fi
    done
    echo
  done
}

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

# OS-specific
case $(uname) in
  "Darwin")
    eval "$(/opt/homebrew/bin/brew shellenv)"

    export HOMEBREW_NO_AUTO_UPDATE=1
    alias pki="HOMEBREW_NO_AUTO_UPDATE=0 brew install "
    alias pkls="brew list "
    alias pks="brew search "
    alias pksh="brew info "
    alias pku="brew update && brew upgrade"
    alias pkr="brew remove "
    alias flushdns='sudo killall -HUP mDNSResponder'

    # load ssh key using keychain if empty agent
    if [[ -n $SSH_AUTH_SOCK ]] && ! ssh-add -l &>/dev/null; then
      ssh-add -K
    fi
    ;;
  "FreeBSD")
      alias pki="sudo pkg install"
      alias pks="pkg search"
      alias pksh="pkg info"
      alias pku="sudo pkg upgrade"
      alias pkr="sudo pkg remove"
    ;;
  "Linux")
    if [[ -e /etc/arch-release ]]; then
      alias pki="sudo pacman -S"
      alias pkls="pacman -Ql"
      alias pkp="pkgfile"
      alias pks="pacman -Ss"
      alias pksh="pacman -Si"
      alias pku="sudo pacman -Syu"
      alias pkr="sudo pacman -R"
    elif [[ -e /etc/debian_version ]]; then
      alias pki="sudo apt install"
      alias pkls="dpkg -L"
      alias pkp="apt-file search"
      alias pks="apt search"
      alias pksh="apt show"
      alias pku="sudo apt update && sudo apt --autoremove dist-upgrade"
      alias pkr="sudo apt purge --autoremove"

      export PATH="$PATH:/usr/sbin:/sbin"
    elif [[ -e /etc/fedora-release ]]; then
      alias pki="sudo dnf --color=auto install"
      alias pkls="rpm -ql"
      alias pkp="dnf --color=auto provides"
      alias pks="dnf --color=auto search"
      alias pksh="dnf --color=auto info"
      alias pku="sudo dnf --color=auto update"
      alias pkr="sudo dnf --color=auto remove"
    elif [[ -e /etc/redhat-release ]]; then
      alias pki="sudo yum --color=auto install"
      alias pkls="rpm -ql"
      alias pkp="yum --color=auto provides"
      alias pks="yum --color=auto search"
      alias pksh="yum --color=auto info"
      alias pku="sudo yum --color=auto update"
      alias pkr="sudo yum --color=auto remove"
    elif [[ -e /etc/alpine-release ]]; then
      alias pki="sudo apk add "
      alias pks="apk search "
      alias pksh="apk info "
      alias pku="sudo apk -U upgrade"
      alias pkr="sudo apk del "
    elif grep -q opensuse /etc/os-release; then
      alias zy="sudo zypper "

      alias pki="sudo zypper install "
      alias pkls="rpm -ql"
      alias pkp="zypper search --provides --file-list "
      alias pks="sudo zypper search "
      alias pksh="zypper info "
      alias pku="sudo zypper refresh && sudo zypper dist-upgrade"
      alias pkr="sudo zypper remove --clean-deps "

      export PATH="$PATH:/usr/sbin:/sbin"
    else
      echo "!! Unsupported Linux distribution"
    fi

    if [[ -d /run/WSL ]]; then
      source ~/bin/wsl-ssh-relay
      ~/bin/wsl-gpg-relay
    fi
    ;;
  "OpenBSD")
    alias pki="sudo pkg_add -i -v "
    alias pku="sudo pkg_add -u -v "
    alias pkls="pkg_info -L "
    ;;
  *)
    echo "!! Unsupported OS: $(uname)"
esac

#
# app specific
#

# ag
if command -v ag &> /dev/null; then
  alias ag="ag --no-break --no-heading --color-match '1;32' --color-path '0;34'"
fi

# ansible
alias ap='ansible-playbook '
alias ac='ansible-container '

# asdf
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE=$HOME/.dotfiles/python-packages

# bundle
alias be='bundle exec '

# colordiff
if command -v colordiff > /dev/null; then
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
  if [ -z "$1" ]
  then
    runcmd="/bin/bash"
  else
    runcmd="$*"
  fi
  # shellcheck disable=SC2086
  docker run -t -i --rm=true $runimg $runcmd
}
dcnet() {
  [[ -z $1 ]] && return 1
  svc=$(docker-compose ps | grep $1 | awk '{print $1}')
  [[ -z $svc ]] && return 1

  docker run -it --net container:$svc nicolaka/netshoot
}

# emacs
if [ -d ~/.emacs.d/bin ]; then
  export PATH="$PATH:$HOME/.emacs.d/bin"
fi
alias em="emacsclient -t"

# fd
if command -v fdfind &>/dev/null; then
  alias fd=fdfind
fi

# git
[[ -e ~/.dotfiles/git-subrepo/.rc ]] && source ~/.dotfiles/git-subrepo/.rc
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
gt () {
  [ -z "$1" ] && git tag -l -n1 && return 0
  # shellcheck disable=SC2068
  git tag $@
}
gitignore() {
  [ -z "$1" ] && echo "missing language to ignore" && return 1

  wget --output-document=.gitignore.tmp "https://raw.githubusercontent.com/github/gitignore/master/$1.gitignore"

  if [[ $? == 0 ]]; then
    if [ -e .gitignore ]; then
      cat .gitignore.tmp >> .gitignore
    else
      mv -v .gitignore.tmp .gitignore
    fi
  fi

  rm -f .gitignore.tmp
}


# gpg
if command -v gpgconf > /dev/null && [[ -n "$XDG_RUNTIME_DIR" && -d "$XDG_RUNTIME_DIR" ]]; then
  [ -e "$(gpgconf --list-dirs agent-socket)" ] || gpgconf --create-socketdir
fi

# grep
export GREP_COLOR='3;32'
alias grep='grep --color=auto'

# gsed
if command -v gsed > /dev/null; then
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

# python
export PYTHONSTARTUP=$HOME/.dotfiles/pythonstartup.py

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgreprc
if command -v rg >/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
fi

# rust
if [ -d "${HOME}/.cargo/bin" ]; then
  export PATH="${HOME}/.cargo/bin:$PATH"
fi

# snap
if command -v snap > /dev/null; then
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
  delip="$(grep "${1}"\  "$HOME"/.ssh/known_hosts | awk '{print $1}' | cut -f 2 -d \, )"

  [[ -n $delip ]] && ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$delip"
  ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$1"
}

# systemd
alias jc="sudo journalctl "
alias jcu="journalctl --user "
alias sy="sudo systemctl "
alias syu="systemctl --user "

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
if [[ "$TERM_PROGRAM" == "vscode" ]]
then
  alias vim=code
  if [[ $TERM_PROGRAM_VERSION == *-insider ]]; then
    alias code=code-insiders
  fi
fi
