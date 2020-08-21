# opensuse notes

## default

~~~bash
sudo zypper install \
       fprintd \
       fprintd-pam \
       git \
       htop \
       kitty \
       ripgrep \
       ShellCheck \
       telegram-desktop \
       tmux
       zsh
sudo chsh -s /bin/zsh adam
sudo hostnamectl set-hostname think
sudo cp sudoers.d/* /etc/sudoers.d/

# disable e1000e since we don't have the adapter
echo blacklist e1000e | sudo tee /etc/modprobe.d/99-myblacklist.conf
~~~

## developer

~~~bash
zypper install gcc libbz2-devel openssl-devel readline-devel sqlite3-devel libffi-devel zlib-devel make
zypper ar -r http://download.opensuse.org/repositories/openSUSE:/Tools/openSUSE_Factory/openSUSE:Tools.repo
zypper in osc
~~~

## fonts

~~~bash
sudo zypper addrepo --refresh --check https://download.opensuse.org/repositories/home:/adamcstephens/openSUSE_Factory/home:adamcstephens.repo
sudo zypper install nerd-fonts-jetbrains-mono
~~~

## gui

~~~bash
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Mono 10'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'kitty.desktop']"
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature uint32 2148
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 6.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-last-coordinates (91.0, 181.0)
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 22.0
~~~

## keyboard

~~~bash
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
gsettings set org.gnome.desktop.peripherals.keyboard delay 210

sudo zypper install python3-evdev python3-six python3-pyudev
sudo groupadd --system uinput
sudo usermod -a -G input,uinput adam
echo uinput | sudo tee /etc/modules-load.d/uinput.conf
echo 'KERNEL=="uinput", GROUP="uinput", MODE:="0660"' | sudo tee /etc/udev/rules.d/99-uinput.rules
~~~

## github

~~~bash
sudo zypper in https://github.com/cli/cli/releases/download/v0.11.1/gh_0.11.1_linux_amd64.rpm
~~~

## slack

~~~bash
sudo zypper addrepo https://download.opensuse.org/repositories/server:messaging/openSUSE_Factory/server:messaging.repo
sudo zypper install slack
~~~

## sonos

~~~bash
# not latest, connects but not all services work
zypper install noson-app

# latest version, not fully functional
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flathub io.github.janbar.noson
~~~

## vscode

~~~bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper addrepo --refresh --check https://packages.microsoft.com/yumrepos/vscode vscode
sudo zypper in code
~~~
