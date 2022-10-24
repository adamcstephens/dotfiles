{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../apps/dunst
    ../apps/eww
    ../apps/gammastep
    ../apps/hyprland
    ../apps/kanshi
    ../apps/river
    ../apps/vscode
    ../apps/wofi
    ../apps/swayidle
  ];

  fonts.fontconfig.enable = true;

  home.packages = [
    config.programs.eww.package
    pkgs.river

    pkgs.material-design-icons
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})

    pkgs.brightnessctl
    pkgs.blueberry
    pkgs.bluez
    pkgs.light
    pkgs.networkmanagerapplet

    # audio
    pkgs.plexamp
    pkgs.playerctl
    pkgs.wireplumber

    # apps
    pkgs._1password-gui
    pkgs.cider
    pkgs.firefox-wayland
    pkgs.kitty
    pkgs.cinnamon.nemo
    pkgs.remmina
    pkgs.slack
    pkgs.tdesktop
    inputs.webcord.packages.${config.nixpkgs.system}.default
  ];

  home.activation.dotfiles-bootstrap-linux-gui = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    pushd ~/.dotfiles
      if [ -e .nixos-managed ]; then
        git pull
      fi
      just dotbot dotbot.linux-gui.yaml
    popd
  '';

  services.gnome-keyring.enable = true;
  services.syncthing.enable = true;

  systemd.user.services.gnome-keyring.Install.WantedBy = config.dotfiles.gui.wantedBy;
  systemd.user.startServices = "sd-switch";
}
