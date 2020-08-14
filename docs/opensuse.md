# opensuse notes

## default

~~~
zypper install htop kitty git fprintd telegram-desktop zsh ripgrep tmux xcape
~~~

## gui

~~~
gsettings set org.gnome.desktop.interface enable-hot-corners false
~~~

## fonts

~~~
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts
~~~

## keyboard

~~~
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
gsettings set org.gnome.desktop.peripherals.keyboard delay 200

sudo zypper install python3-evdev python3-six python3-udev
sudo addgroup -r uinput
sudo usermod -a -G input,uinput adam
echo uinput | sudo /etc/modules-load.d/uinput.conf
echo 'KERNEL=="uinput", GROUP="uinput", MODE:="0660"' | sudo tee /etc/udev/rules.d/99-uinput.rules
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
