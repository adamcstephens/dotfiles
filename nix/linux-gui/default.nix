{
  config,
  inputs',
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../apps/dunst
    ../../apps/eww
    ../../apps/gammastep
    ../../apps/kanshi
    ../../apps/river
    ../../apps/vscode
    ../../apps/wofi
    ../../apps/swayidle
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "slack"
      "vscode"
    ];

  services.gnome-keyring.enable = true;
  systemd.user.services.gnome-keyring = {
    Install = {
      WantedBy = ["river-session.target"];
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.river

    pkgs.material-design-icons
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})

    pkgs.bluez
    pkgs.light
    pkgs.networkmanagerapplet

    # audio
    pkgs.wireplumber

    # apps
    pkgs.cider
    pkgs.kitty
    pkgs.slack
    pkgs.tdesktop
    inputs'.webcord.packages.default
  ];

  home.activation.dotfiles-bootstrap-linux-gui = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    pushd ~/.dotfiles
      if [ -e .nixos-managed ]; then
        git pull
      fi
      CONFIG=dotbot.linux-gui.yaml task dotbot
    popd
  '';

  systemd.user.startServices = "sd-switch";
}
