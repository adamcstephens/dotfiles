source <(kubectl completion zsh)

source ~/.fresh/build/zsh/kubectl.zsh
RPROMPT="${RPS1}%{$fg[blue]%}(\$ZSH_KUBECTL_PROMPT)%{$reset_color%}"
