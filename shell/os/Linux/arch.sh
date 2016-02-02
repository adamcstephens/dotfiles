# support newer grep
alias grep='grep --color=auto'
unset GREP_OPTIONS

# packages
alias pki="sudo pacman -S"
alias pkls="pacman -Ql"
alias pkp="pkgfile"
alias pks="pacman -Ss"
alias pksh="pacman -Si"
alias pku="sudo pacman -Syu"
alias pkr="sudo pacman -R"
which pacaur &>/dev/null && alias pacaur="pacaur --noedit"
alias apacman="apacman --noedit"
