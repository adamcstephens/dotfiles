if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update
fi

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-completions", depth:1

zplug "plugins/docker",         from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh, as:plugin
zplug "~/.fresh/source/freshshell/fresh/contrib/completion/fresh-completion.zsh", from:local

# Source after compinit to enable completion
zplug "knu/z", use:z.sh, defer:2

# self-manage zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# this is loaded last
zplug "zsh-users/zsh-syntax-highlighting"

# zplug check returns true if all packages are installed
# Therefore, when it returns false, run zplug install
if ! zplug check; then
    zplug install
fi

zplug load --verbose
