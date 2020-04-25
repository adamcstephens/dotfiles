source ~/.zplugin/bin/zplugin.zsh

zplugin ice wait'!0' lucid
zplugin light "MikeDacre/tmux-zsh-vim-titles"

zplugin ice wait'!0' lucid
zplugin light "greymd/docker-zsh-completion"

zplugin ice wait'!0' lucid
zplugin light "hlissner/zsh-autopair"

zplugin ice wait lucid atload'_zsh_autosuggest_start'
zplugin light "zsh-users/zsh-autosuggestions"

zplugin light "zdharma/fast-syntax-highlighting"

# zplugin light "~/.fresh/source/freshshell/fresh/contrib/completion/fresh-completion.zsh"

# Load the pure theme, with zsh-async library that's bundled with it.
zplugin ice pick"async.zsh" src"pure.zsh"
zplugin light "sindresorhus/pure"

# use installed direnv and generate a hook file
zplugin ice from"gh-r" as"program" mv"direnv* -> direnv" atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' pick"direnv" src"zhook.zsh"
zplugin light direnv/direnv
alias da="direnv allow"

PROMPT=' %(?.%F{magenta}->.%F{red}~>)%f '

if [[ -e ~/.ssh/id_ed25519 ]] || [[ -e ~/.ssh/id_rsa ]]; then
  zplugin snippet OMZ::plugins/ssh-agent/ssh-agent.plugin.zsh
fi

if [[ -e $HOME/.asdf/asdf.sh ]]; then
  source $HOME/.asdf/asdf.sh
  fpath=(${ASDF_DIR}/completions $fpath)
fi
