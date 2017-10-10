if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update
fi

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-completions", depth:1

zplug "plugins/docker",         from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh, as:plugin
zplug "plugins/systemd", from:oh-my-zsh, as:plugin, if:"which systemctl"
zplug "plugins/nomad", from:oh-my-zsh, as:plugin, if:"which nomad"
zplug "~/.fresh/source/freshshell/fresh/contrib/completion/fresh-completion.zsh", from:local

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
