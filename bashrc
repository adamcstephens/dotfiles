#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -e $HOME/.bash_profile ] && . $HOME/.bash_profile

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
