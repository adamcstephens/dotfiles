alias pki="brew install "
alias pkls="brew ls --verbose "
alias pkr="brew remove "
alias pks="brew search "
alias pksh="brew info "
alias pku="brew update && brew upgrade"

if [ -d $HOME/.homebrew/bin ]
then
  export PATH="$HOME/.homebrew/bin:$PATH"
fi
if [ -d $HOME/.homebrew/sbin ]
then
  export PATH="$HOME/.homebrew/sbin:$PATH"
fi
