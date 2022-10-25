#!/usr/bin/env sh

# OS-specific
case $(uname) in
"Darwin")
  if [ -e /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  export HOMEBREW_NO_AUTO_UPDATE=1
  pki="HOMEBREW_NO_AUTO_UPDATE=0 brew install "
  pkls="brew list "
  pkr="brew remove "
  pks="brew search "
  pksh="brew info "
  pku="brew update && brew upgrade"
  ;;
"FreeBSD")
  pki="sudo pkg install"
  pkr="sudo pkg remove"
  pks="pkg search"
  pksh="pkg info"
  pku="sudo pkg upgrade"
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
    pkr="$pkgcmd -R --recursive"
    pks="$pkgcmd -Ss"
    pksh="$pkgcmd -Si"
    pku="$pkgcmd -Syu"
  elif [ -e /etc/debian_version ]; then
    pki="sudo apt install"
    pkls="dpkg -L"
    pkp="apt-file search"
    pkr="sudo apt purge --autoremove"
    pks="apt search"
    pksh="apt show"
    pku="sudo apt update && sudo apt --autoremove dist-upgrade"
  elif [ -e /etc/fedora-release ]; then
    pki="sudo dnf --color=auto install"
    pkls="rpm -ql"
    pkp="dnf --color=auto provides"
    pkr="sudo dnf --color=auto remove"
    pks="dnf --color=auto search"
    pksh="dnf --color=auto info"
    pku="sudo dnf --color=auto update"
  elif [ -e /etc/redhat-release ]; then
    pki="sudo yum --color=auto install"
    pkls="rpm -ql"
    pkp="yum --color=auto provides"
    pkr="sudo yum --color=auto remove"
    pks="yum --color=auto search"
    pksh="yum --color=auto info"
    pku="sudo yum --color=auto update"
  elif [ -e /etc/alpine-release ]; then
    pki="sudo apk add "
    pkls="apk info -L "
    pkr="sudo apk del "
    pks="apk search "
    pksh="apk info "
    pku="sudo apk -U upgrade"
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
    pkr="sudo zypper remove --clean-deps "
    pks="sudo zypper search "
    pksh="zypper info "
    pku="sudo zypper refresh && sudo zypper dist-upgrade"
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

export pki
export pkls
export pkp
export pkr
export pks
export pksh
export pku

run() {
  eval cmd='$'"$1"
  shift 1

  if [ -z "$cmd" ]; then
    echo "Unsupported command on platform"
    exit 1
  fi

  # shellcheck disable=SC2154
  eval "$cmd $*"
}
