[[ -e "$HOME/.shell_generic.sh" ]] && . "$HOME/.shell_generic.sh"

# shorten long paths
export PROMPT_DIRTRIM=2

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

MY_COLORRESET="\[\033[0m\]"
MY_DIM="\[\033[2m\]"

MY_BLACK="\[\033[0;30m\]"
MY_RED="\[\033[0;31m\]"
MY_GREEN="\[\033[0;32m\]"
MY_BROWN="\[\033[0;33m\]"
MY_BLUE="\[\033[0;34m\]"
MY_PURPLE="\[\033[0;35m\]"
MY_CYAN="\[\033[0;36m\]"
MY_LTGRAY="\[\033[0;37m\]"

MY_DKGRAY="\[\033[1;30m\]"
MY_LTRED="\[\033[1;31m\]"
MY_LTGREEN="\[\033[1;32m\]"
MY_YELLOW="\[\033[1;33m\]"
MY_LTBLUE="\[\033[1;34m\]"
MY_LTPURPLE="\[\033[1;35m\]"
MY_LTCYAN="\[\033[1;36m\]"
MY_WHITE="\[\033[1;37m\]"

if [ -f /usr/share/git/completion/git-prompt.sh ]; then # archlinux
  source /usr/share/git/completion/git-prompt.sh
elif [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then # centos
  source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

if [[ $USER == 'root' ]]; then
  USERSTRING="${MY_LTRED}\u"
elif [[ $USER == 'adam' || $USER == 'adam.c.stephens' ]]; then
  USERSTRING=""
else
  USERSTRING="\u"
fi

if declare -f __git_ps1 >/dev/null 2>&1; then
  MYGITPROMPT="${MY_GREEN}\$(__git_ps1)"
else
  MYGITPROMPT=''
fi
export PS1="\n${MY_DIM}╭─ ${USERSTRING}@\h${MY_COLORRESET} ${MY_BLUE}\w${MYGITPROMPT}${MY_COLORRESET}\n${MY_DIM}╰─${MY_BROWN}❯${MY_COLORRESET} "

if [[ $TERM =~ xterm.* ]]; then
  export PROMPT_COMMAND='echo -ne "\033]0;@${HOSTNAME}\007"'
fi

export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=1
export GIT_PS1_SHOWCOLORHINTS=1

#asdf
if [[ -e $HOME/.asdf/asdf.sh ]]; then
  # shellcheck disable=SC1090
  source "$HOME/.asdf/asdf.sh"
  source "$HOME/.asdf/completions/asdf.bash"

  source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/bashrc"
fi

# fzf
[[ -e ~/.fzf.bash ]] && source ~/.fzf.bash

if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash --cmd j)"
fi
