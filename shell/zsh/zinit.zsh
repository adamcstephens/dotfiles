source ~/.zinit/bin/zinit.zsh

# zinit ice wait'!0' lucid
# zinit light "hlissner/zsh-autopair"

zinit wait lucid light-mode for \
  MikeDacre/tmux-zsh-vim-titles \
atinit"zicompinit; zicdreplay" \
  zdharma/fast-syntax-highlighting \
atload'_zsh_autosuggest_start' \
  zsh-users/zsh-autosuggestions \
as"completion" \
  1995parham/buffalo.zsh \
  greymd/docker-zsh-completion

# zinit light "~/.fresh/source/freshshell/fresh/contrib/completion/fresh-completion.zsh"

# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light "sindresorhus/pure"

# use installed direnv and generate a hook file
zinit ice from"gh-r" as"program" mv"direnv* -> direnv" atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' pick"direnv" src"zhook.zsh"
zinit light direnv/direnv
alias da="direnv allow"

PROMPT=' %(?.%F{magenta}->.%F{red}~>)%f '

if [[ -e ~/.ssh/id_ed25519 ]] || [[ -e ~/.ssh/id_rsa ]]; then
  zinit snippet OMZ::plugins/ssh-agent/ssh-agent.plugin.zsh
fi

if [[ -e $HOME/.asdf/asdf.sh ]]; then
  source $HOME/.asdf/asdf.sh
  fpath=(${ASDF_DIR}/completions $fpath)
fi
