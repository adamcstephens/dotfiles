{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../apps/dunst
    ../apps/gammastep
    ../apps/hyprland
    ../apps/kanshi
    ../apps/kitty
    ../apps/river
    ../apps/vscode
    ../apps/wofi
    ../apps/swayidle
    ../apps/waybar
    ../apps/wob
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    theme.package = pkgs.gnome.gnome-themes-extra;
  };

  home.packages = [
    pkgs.font-awesome
    pkgs.material-icons
    pkgs.material-design-icons
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})

    pkgs.brightnessctl
    pkgs.blueberry
    pkgs.bluez
    pkgs.light
    pkgs.networkmanagerapplet
    pkgs.wl-clipboard

    # audio
    pkgs.plexamp
    pkgs.pavucontrol
    pkgs.playerctl
    pkgs.wireplumber

    # apps
    pkgs._1password-gui
    pkgs.cider
    pkgs.firefox-wayland
    pkgs.cinnamon.nemo
    pkgs.remmina
    pkgs.slack
    pkgs.tdesktop
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

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  services.gnome-keyring.enable = true;
  systemd.user.startServices = "sd-switch";
}
