case $DIST in
  'AIX')
    ;;
  'arch')
    alias pki="sudo pacman -S"
    alias pkls="pacman -Ql"
    alias pkp="pkgfile"
    alias pks="pacman -Ss"
    alias pksh="pacman -Si"
    alias pku="sudo pacman -Syu"
    alias pkr="sudo pacman -R"
    which pacaur &>/dev/null && alias pacaur="pacaur --noedit"
    alias apacman="apacman --noedit"
    ;;
  'coreos')
    ;;
  'Darwin')
    alias pki="brew install "
    alias pks="brew search "
    alias pksh="brew info "
    alias pku="brew update && brew upgrade"
    alias pkr="brew remove "
    ;;
  'debian')
    alias pki="sudo apt-get install"
    alias pkls="dpkg -L"
    alias pkp="apt-file search"
    alias pks="apt-cache search"
    alias pksh="apt-cache show"
    alias pku="sudo apt-get update && sudo apt-get dist-upgrade"
    alias pkr="sudo apt-get remove"
    ;;
  'FreeBSD')
    alias pki="sudo pkg install"
    alias pks="pkg search"
    alias pksh="pkg info"
    alias pku="sudo freebsd-update fetch && sudo freebsd-update install"
    ;;
  'OpenBSD')
    alias pki="sudo pkg_add -i -v "
    alias pku="sudo pkg_add -u -v "
    alias pkls="pkg_info -L "
    ;;
  'redhat')
    alias pki="sudo yum install"
    alias pkls="rpm -ql"
    alias pkp="yum provides"
    alias pks="yum search"
    alias pksh="yum info"
    alias pku="sudo yum update"
    alias pkr="sudo yum remove"
    ;;
  *)
    echo "Unknown distribution in packages.sh"
    ;;
esac
