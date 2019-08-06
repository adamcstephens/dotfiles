source ~/.zplug/init.zsh

zplug "hlissner/zsh-autopair"
zplug "MikeDacre/tmux-zsh-vim-titles"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"

zplug "~/.fresh/source/freshshell/fresh/contrib/completion/fresh-completion.zsh", from:local

zplug "kiurchv/asdf.plugin.zsh", defer:2

# self-manage zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug romkatv/powerlevel10k, use:powerlevel10k.zsh-theme


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

source ~/.zplug/repos/romkatv/powerlevel10k/config/p10k-pure.zsh
