# opensuse notes

## default

~~~bash
sudo zypper install \
       bat \
       colordiff \
       direnv \
       fprintd \
       fprintd-pam \
       git \
       htop \
       httpie \
       kitty \
       pwgen \
       ripgrep \
       ShellCheck \
       telegram-desktop \
       tmux \
       u2f-host \
       yubikey-manager \
       zsh
sudo chsh -s /bin/zsh adam
sudo hostnamectl set-hostname think

# TODO: move this to infra control
sudo cp sudoers.d/* /etc/sudoers.d/

# disable e1000e since we don't have the adapter
echo blacklist e1000e | sudo tee /etc/modprobe.d/99-myblacklist.conf

# switch to packman for non-free video codecs
sudo zypper ar -cfp 90 http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials packman-essentials
sudo zypper dup --from packman-essentials --allow-vendor-change

# grant native serial access
sudo usermod -a -G dialout adam

# set up trusted firewall zone
nmcli show
nmcli c modify $UUID connection.zone home
~~~

## kernel

Set /etc/default/grub

~~~bash
# normal mode only
GRUB_CMDLINE_LINUX_DEFAULT="splash=silent mitigations=auto quiet mem_sleep_default=deep"
# normal and recovery
GRUB_CMDLINE_LINUX=""
~~~

Run:

~~~bash
grub2-mkconfig -o /boot/grub2/grub.cfg
~~~

## bluetooth

~~~bash
sudo zypper addrepo https://download.opensuse.org/repositories/home:MasterPatricko/openSUSE_Tumbleweed/home:MasterPatricko.repo
sudo zypper refresh
sudo zypper install pulseaudio-modules-bt
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
# deps for gnome system-monitor
sudo zypper install gnome-shell-devel libgtop-devel libgtop-2_0-11

gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono NF 12'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'kitty.desktop']"
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature uint32 2148
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 6.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-last-coordinates (91.0, 181.0)
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 22.0
gsettings set org.gnome.desktop.interface text-scaling-factor 1.5
~~~

## keyboard

~~~bash
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
gsettings set org.gnome.desktop.peripherals.keyboard delay 230

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

## iphone

~~~bash
sudo zypper install libimobiledevice-tools
idevicebackup2 backup --full backup/iphone
~~~

## joplin

~~~bash
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash
~~~

## slack

~~~bash
sudo zypper addrepo https://download.opensuse.org/repositories/server:messaging/openSUSE_Factory/server:messaging.repo
sudo zypper install slack
~~~

## snap

~~~bash
sudo zypper addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
sudo zypper install snapd
sudo systemctl enable --now snapd snapd.apparmor
~~~

## sonos

~~~bash
# not latest, connects but not all services work
zypper install noson-app

# latest version, not fully functional
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flathub io.github.janbar.noson
~~~

## terminal

~~~bash
profileid=$(gsettings get org.gnome.Terminal.ProfilesList default)
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileid/ scrollback-unlimited true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileid/ cursor-blink-mode 'off'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileid/ foreground-color 'rgb(225,227,228)'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileid/ background-color 'rgb(43,45,58)'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileid/ palette "['rgb(24,26,28)', 'rgb(251,97,126)', 'rgb(158,208,108)', 'rgb(237,199,99)', 'rgb(109,202,232)', 'rgb(187,151,238)', 'rgb(248,152,96)', 'rgb(225,227,228)', 'rgb(126,130,148)', 'rgb(251,97,126)', 'rgb(158,208,108)', 'rgb(237,199,99)', 'rgb(109,202,232)', 'rgb(187,151,238)', 'rgb(248,152,96)', 'rgb(225,227,228)']"
~~~

## vscode

~~~bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper addrepo --refresh --check https://packages.microsoft.com/yumrepos/vscode vscode
sudo zypper in code
~~~
