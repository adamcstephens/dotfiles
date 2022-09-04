# bootstrap znap
zstyle ':znap:*' repos-dir ~/.znap
source ~/.dotfiles/zsh-snap/znap.zsh

# znap prompt

# asdf
if [[ -e $HOME/.asdf/asdf.sh ]]; then
  source $HOME/.asdf/asdf.sh
  fpath=("${ASDF_DIR}/completions" $fpath)
fi

# git-subrepo
fpath=("$HOME/.dotfiles/zsh-completion" "$HOME/.dotfiles/git-subrepo/share/zsh-completion" $fpath)

ZSH_AUTOSUGGEST_STRATEGY=( history )
znap source zsh-users/zsh-autosuggestions

ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7e8294"
znap source sainnhe/sonokai zsh/.zsh-theme-sonokai-andromeda

znap source MikeDacre/tmux-zsh-vim-titles

asdf_direnv_zshrc="${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
if [ -e $asdf_direnv_zshrc ]; then
  source $asdf_direnv_zshrc
fi

# # shellcheck shell=bash
# autoload -Uz compinit && compinit

# # completion
# zmodload zsh/complist
# autoload -U +X bashcompinit && bashcompinit

# # case-insensitive (all),partial-word and then substring completion
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# # promptinit
# autoload -U promptinit && promptinit

# history
export HISTSIZE=10000000
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history
# setopt share_history
alias history='fc -l 1 | less'

# 10ms for key sequences
export KEYTIMEOUT=1

setopt extendedglob

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

# shellcheck disable=SC1090
[[ -e "$HOME/.shell_generic.sh" ]] && source "$HOME/.shell_generic.sh"

# brew
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# prompt
eval "$(starship init zsh)"

# direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# fzf
if [[ -e ~/.fzf.zsh ]]
then
   source ~/.fzf.zsh 2>/dev/null
fi

# kubectl
if command -v kubectl &>/dev/null; then
  znap compdef _kubectl 'kubectl completion zsh'
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd j)"
fi

[[ -e /usr/share/google-cloud-sdk/completion.zsh.inc ]] && source /usr/share/google-cloud-sdk/completion.zsh.inc

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh 2>/dev/null)"

source $HOME/.dotfiles/iterm2.zsh

# i don't care what happened above when the prompt starts
true
