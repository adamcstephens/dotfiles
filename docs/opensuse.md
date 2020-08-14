# opensuse notes

## default

~~~
zypper install htop kitty git fprintd telegram-desktop zsh ripgrep tmux xcape
~~~

## fonts

~~~
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts
~~~

## keyboard

~~~
sudo zypper addrepo https://download.opensuse.org/repositories/home:/mnemitz/openSUSE_Tumbleweed/ xcape
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
gsettings set org.gnome.desktop.peripherals.keyboard delay 250
~~~

## sonos

~~~
# not latest, connects but not all services work
zypper install noson-app

# latest version, not fully functional
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flathub io.github.janbar.noson
~~~


## slack

~~~
sudo zypper addrepo https://download.opensuse.org/repositories/server:messaging/openSUSE_Factory/server:messaging.repo
sudo zypper install slack
~~~
