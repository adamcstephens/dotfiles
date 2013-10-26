alias pi='sudo pacman -S'
alias pqs='sudo pacman -Ss'
alias pyu='sudo pacman -Syu'

# debian
alias acs="apt-cache search"
alias acsh="apt-cache show"
alias adg="sudo apt-get update && sudo apt-get dist-upgrade"
alias ai="sudo apt-get install"

function pks () {
  [ -z $1 ] && return 5
  case $DIST in
    'arch')
      pacman -Ss $1
      ;;
    'debian')
      apt-cache search $1
      ;;
    'redhat')
      yum search $1
      ;;
    *)
      return 6
      ;;
  esac
}

function pki () {
  [ -x $1 ] && return 5
  case $DIST in
    'arch')
      sudo pacman -S $@
      ;;
    'debian')
      sudo apt-get install $@
      ;;
    'redhat')
      sudo yum install $@
      ;;
    *)
      return 6
      ;;
  esac
}

function pkp () {
  [ -x $1 ] && return 5
  case $DIST in
    'arch')
      pkgfile $1
      ;;
    'debian')
      apt-file search $1
      ;;
    'redhat')
      yum provides $1
      ;;
    *)
      return 6
      ;;
  esac
}

function pku () {
  case $DIST in
    'arch')
      sudo pacman -Syu
      ;;
    'debian')
      sudo apt-get update && sudo apt-get dist-upgrade
      ;;
    'redhat')
      sudo yum update
      ;;
    *)
      return 6
      ;;
  esac
}
