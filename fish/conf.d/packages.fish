switch (uname)
    case Darwin
        set HOMEBREW_NO_AUTO_UPDATE 1
        alias pki="HOMEBREW_NO_AUTO_UPDATE=0 brew install "
        alias pkls="brew list "
        alias pks="brew search "
        alias pksh="brew info "
        alias pku="brew update && brew upgrade"
        alias pkr="brew remove "
        alias flushdns='sudo killall -HUP mDNSResponder'
        alias syu="brew services"
    case FreeBSD
        alias pki="sudo pkg install"
        alias pks="pkg search"
        alias pksh="pkg info"
        alias pku="sudo pkg upgrade"
        alias pkr="sudo pkg remove"
    case OpenBSD
        alias pki="sudo pkg_add -i -v "
        alias pku="sudo pkg_add -u -v "
        alias pkls="pkg_info -L "
    case Linux
        alias jc="sudo journalctl "
        alias jcu="journalctl --user "
        alias sy="sudo systemctl "
        alias syu="systemctl --user "

        if [ -e /etc/arch-release ]
            if command -v yay &>/dev/null
                set pkgcmd yay
            else
                set pkgcmd "sudo pacman"
            end
            alias pki="$pkgcmd -S"
            alias pkls="$pkgcmd -Ql"
            alias pkp="pkgfile"
            alias pks="$pkgcmd -Ss"
            alias pksh="$pkgcmd -Si"
            alias pku="$pkgcmd -Syu"
            alias pkr="$pkgcmd -R --recursive"
        else if [ -e /etc/debian_version ]
            alias pki="sudo apt install"
            alias pkls="dpkg -L"
            alias pkp="apt-file search"
            alias pks="apt search"
            alias pksh="apt show"
            alias pku="sudo apt update && sudo apt --autoremove dist-upgrade"
            alias pkr="sudo apt purge --autoremove"
        else if [ -e /etc/fedora-release ]
            alias pki="sudo dnf --color=auto install"
            alias pkls="rpm -ql"
            alias pkp="dnf --color=auto provides"
            alias pks="dnf --color=auto search"
            alias pksh="dnf --color=auto info"
            alias pku="sudo dnf --color=auto update"
            alias pkr="sudo dnf --color=auto remove"
        else if [ -e /etc/redhat-release ]
            alias pki="sudo yum --color=auto install"
            alias pkls="rpm -ql"
            alias pkp="yum --color=auto provides"
            alias pks="yum --color=auto search"
            alias pksh="yum --color=auto info"
            alias pku="sudo yum --color=auto update"
            alias pkr="sudo yum --color=auto remove"
        else if [ -e /etc/alpine-release ]
            alias pki="sudo apk add "
            alias pks="apk search "
            alias pksh="apk info "
            alias pku="sudo apk -U upgrade"
            alias pkr="sudo apk del "
        else if grep -q void /etc/os-release
            alias pki="sudo xbps-install "
            alias pkls="xbps-query -f "
            alias pkp="sudo xclocate "
            alias pks="xbps-query -Rs "
            alias pksh="xbps-query -RS "
        else if grep -q opensuse /etc/os-release
            alias zy="sudo zypper "
            alias pki="sudo zypper install "
            alias pkls="rpm -ql"
            alias pkp="zypper search --provides --file-list "
            alias pks="sudo zypper search "
            alias pksh="zypper info "
            alias pku="sudo zypper refresh && sudo zypper dist-upgrade"
            alias pkr="sudo zypper remove --clean-deps "
        end
    case '*'
        echo "Unsupported platform (uname)"
end
