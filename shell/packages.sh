# arch
alias pi='sudo pacman -S'
alias pqs='sudo pacman -Ss'
alias pyu='sudo pacman -Syu'

# debian
alias acs="apt-cache search"
alias acsh="apt-cache show"
alias adg="sudo apt-get update && sudo apt-get dist-upgrade"
alias ai="sudo apt-get install"

case $DIST in
  'arch')
    alias pki="sudo pacman -S"
    alias pkp="pkgfile"
    alias pks="pacman -Ss"
    alias pksh="pacman -S"
    alias pku="sudo pacman -Syu"
    ;;
  'debian')
    alias pki="sudo apt-get install"
    alias pkp="apt-file search"
    alias pks="apt-cache search"
    alias pksh="apt-cache show"
    alias pku="sudo apt-get update && sudo apt-get dist-upgrade"
    ;;
  'redhat')
    alias pki="sudo yum install"
    alias pkp="yum provides"
    alias pks="yum search"
    alias pksh="yum info"
    alias pku="sudo yum update"
    ;;
  *)
    echo "Unknown distribution"
    ;;
esac
