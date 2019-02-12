source ~/.zplug/init.zsh

# zplug "zsh-users/zsh-completions", depth:1
zplug "zsh-users/zsh-autosuggestions"

# zplug "plugins/docker",         from:oh-my-zsh
# zplug "plugins/docker-compose", from:oh-my-zsh, as:plugin
zplug "~/.fresh/source/freshshell/fresh/contrib/completion/fresh-completion.zsh", from:local
zplug "kiurchv/asdf.plugin.zsh", defer:2

# self-manage zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

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
