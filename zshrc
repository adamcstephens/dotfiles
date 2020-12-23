# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# shellcheck shell=bash
autoload -Uz compinit && compinit

#asdf - here because of load order
if [[ -e $HOME/.asdf/asdf.sh ]]; then
  # shellcheck disable=SC1090
  source "$HOME/.asdf/asdf.sh"
  fpath=("${ASDF_DIR}/completions" $fpath)
fi

zstyle :omz:plugins:ssh-agent agent-forwarding on

# shellcheck disable=SC1090
source ~/.zsh_plugins.sh

# completion
compinit
zmodload zsh/complist
autoload -U +X bashcompinit && bashcompinit

# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
      'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# promptinit
autoload -U promptinit && promptinit

# prompt colors
setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

# history
export HISTSIZE=100000
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
# ignore commands started with a space
setopt HIST_IGNORE_SPACE

# 10ms for key sequences
export KEYTIMEOUT=1

#
setopt extendedglob

# override history
alias history='fc -l 1 | less'
# save history immediately
setopt inc_append_history
# share history between terminals
# setopt share_history

# allow comments in interactive shell
setopt interactivecomments

# word separation for movement
export WORDCHARS='*?_[]~;!#$%^(){}.-'

# set emacs mode
bindkey -e
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# enable edit-command-line
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# brew
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# fzf
if [[ -e ~/.fzf.zsh ]]
then
  source ~/.fzf.zsh
fi

# shellcheck disable=SC1090
[[ -e "$HOME/.shell_generic.sh" ]] && source "$HOME/.shell_generic.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -e /usr/share/google-cloud-sdk/completion.zsh.inc ]] && source /usr/share/google-cloud-sdk/completion.zsh.inc

# manually import the ssh plugin if no agent
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  source <(antibody init)
  antibody bundle robbyrussell/oh-my-zsh path:plugins/ssh-agent
fi
