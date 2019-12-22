source ~/.zplug/init.zsh

zplug "MikeDacre/tmux-zsh-vim-titles"
zplug "greymd/docker-zsh-completion"
zplug "hlissner/zsh-autopair"
zplug "zsh-users/zsh-autosuggestions"

zplug "~/.fresh/source/freshshell/fresh/contrib/completion/fresh-completion.zsh", from:local

zplug "kiurchv/asdf.plugin.zsh", defer:2

# self-manage zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Async for zsh, used by pure
zplug "mafredri/zsh-async", from:github, defer:0
# # Theme!
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

# this is loaded last
zplug "zdharma/fast-syntax-highlighting"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

if command -v direnv &> /dev/null
then
  eval "$(direnv hook zsh)"
fi
