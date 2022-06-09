#!/usr/bin/env sh

# OS-specific
case $(uname) in
"Darwin")
  if [ -e /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  HOMEBREW_NO_AUTO_UPDATE=1
  pki="HOMEBREW_NO_AUTO_UPDATE=0 brew install "
  pkls="brew list "
  pks="brew search "
  pksh="brew info "
  pku="brew update && brew upgrade"
  pkr="brew remove "
  flushdns='sudo killall -HUP mDNSResponder'
  syu="brew services"
  ;;
"FreeBSD")
  pki="sudo pkg install"
  pks="pkg search"
  pksh="pkg info"
  pku="sudo pkg upgrade"
  pkr="sudo pkg remove"
  ;;
"Linux")
  if [ -e /etc/arch-release ]; then
    if
      command -v yay >/dev/null 2>&2
    then
      pkgcmd="yay"
    else
      pkgcmd="sudo pacman"
    fi
    pki="$pkgcmd -S"
    pkls="$pkgcmd -Ql"
    pkp="pkgfile"
    pks="$pkgcmd -Ss"
    pksh="$pkgcmd -Si"
    pku="$pkgcmd -Syu"
    pkr="$pkgcmd -R --recursive"
  elif [ -e /etc/debian_version ]; then
    pki="sudo apt install"
    pkls="dpkg -L"
    pkp="apt-file search"
    pks="apt search"
    pksh="apt show"
    pku="sudo apt update && sudo apt --autoremove dist-upgrade"
    pkr="sudo apt purge --autoremove"
  elif [ -e /etc/fedora-release ]; then
    pki="sudo dnf --color=auto install"
    pkls="rpm -ql"
    pkp="dnf --color=auto provides"
    pks="dnf --color=auto search"
    pksh="dnf --color=auto info"
    pku="sudo dnf --color=auto update"
    pkr="sudo dnf --color=auto remove"
  elif [ -e /etc/redhat-release ]; then
    pki="sudo yum --color=auto install"
    pkls="rpm -ql"
    pkp="yum --color=auto provides"
    pks="yum --color=auto search"
    pksh="yum --color=auto info"
    pku="sudo yum --color=auto update"
    pkr="sudo yum --color=auto remove"
  elif [ -e /etc/alpine-release ]; then
    pki="sudo apk add "
    pks="apk search "
    pkls="apk info -L "
    pksh="apk info "
    pku="sudo apk -U upgrade"
    pkr="sudo apk del "
  elif grep -q void /etc/os-release; then
    pki="sudo xbps-install "
    pkls="xbps-query -f "
    pkp="sudo xclocate "
    pks="xbps-query -Rs "
    pksh="xbps-query -RS "
  elif grep -q opensuse /etc/os-release; then
    pki="sudo zypper install "
    pkls="rpm -ql"
    pkp="zypper search --provides --file-list "
    pks="sudo zypper search "
    pksh="zypper info "
    pku="sudo zypper refresh && sudo zypper dist-upgrade"
    pkr="sudo zypper remove --clean-deps "
  else
    echo "!! Unsupported Linux distribution"
  fi
  ;;
"OpenBSD")
  pki="sudo pkg_add -i -v "
  pku="sudo pkg_add -u -v "
  pkls="pkg_info -L "
  ;;
*)
  echo "!! Unsupported OS: $(uname)"
  ;;
esac

run() {
  eval cmd='$'$1
  shift 1

  if [ -z "$cmd" ]; then
    echo "Unsupported command on platform"
    exit 1
  fi

  # shellcheck disable=SC2154
  eval "$cmd $*"
}
