# opensuse server setup

Installed with only base and apparmor

```bash
zypper addrepo https://download.opensuse.org/repositories/filesystems/openSUSE_Leap_15.2/filesystems.repo

zypper install \
  curl
  hdparm
  iftop
  iotop
  iputils
  man
  smartmontools
  sudo
  tcpdump
  unzip
  vim
  wget
  zfs
  yast2-network

zypper install --no-recommends man

zypper install \
  bat \
  colordiff \
  direnv \
  git \
  htop \
  httpie \
  make \
  pwgen \
  ripgrep \
  ShellCheck \
  tmux \
  zsh
```

## system configs

### zwave/zigbee

```bash
❯ 'cat' /etc/udev/rules.d/99-usb-serial.rules
SUBSYSTEM=="tty", ATTRS{interface}=="HubZ Z-Wave Com Port", SYMLINK+="zwave"
SUBSYSTEM=="tty", ATTRS{interface}=="HubZ ZigBee Com Port", SYMLINK+="zigbee"
```

### zfs

```bash
zypper addrepo https://download.opensuse.org/repositories/filesystems/openSUSE_Leap_15.2/filesystems.repo
zypper install zfs

❯ 'cat' /etc/modprobe.d/zfs.conf
# Min 2GB / Max 12GB Limit
options zfs zfs_arc_min=2147483648
options zfs zfs_arc_max=12884901888
```

### network

```bash
zypper in openvswitch
ovs-vsctl add-br ovsbr0
ovs-vsctl add-bond ovsbr0 bond0 eth1 eth2 eth3 eth4 lacp=active
ovs-vsctl add-br vlan14 ovsbr0 14
```
