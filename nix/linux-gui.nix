{
  config,
  lib,
  pkgs,
  ...
}: let
  configure-gtk = pkgs.writeScriptBin "configure-gtk" (let
    schema = pkgs.gsettings-desktop-schemas;
    datadir = "${schema}/share/gsettings-schemas/${schema.name}";
  in ''
    export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
    gnome_schema=org.gnome.desktop.interface
  '');
in {
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
    ../apps/wezterm
    ../apps/wob
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 24;
    };
  };

  home.packages = [
    pkgs.font-awesome
    pkgs.material-icons
    pkgs.material-design-icons
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})

    configure-gtk
    pkgs.glib

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

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  services.gnome-keyring.enable = true;
  systemd.user.startServices = "sd-switch";
}
