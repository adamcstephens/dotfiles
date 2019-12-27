source ~/.zplugin/bin/zplugin.zsh

zplugin ice wait'!0'
zplugin light "MikeDacre/tmux-zsh-vim-titles"

zplugin ice wait'!0'
zplugin light "greymd/docker-zsh-completion"

zplugin ice wait'!0'
zplugin light "hlissner/zsh-autopair"

zplugin ice wait lucid atload'_zsh_autosuggest_start'
zplugin light "zsh-users/zsh-autosuggestions"

zplugin light "zdharma/fast-syntax-highlighting"

# zplugin light "~/.fresh/source/freshshell/fresh/contrib/completion/fresh-completion.zsh"

zplugin light "kiurchv/asdf.plugin.zsh"

# Load the pure theme, with zsh-async library that's bundled with it.
zplugin ice pick"async.zsh" src"pure.zsh"
zplugin light "sindresorhus/pure"

# use installed direnv and generate a hook file
zplugin ice from"gh-r" as"program" mv"direnv* -> direnv" atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' pick"direnv" src"zhook.zsh"
zplugin light direnv/direnv
