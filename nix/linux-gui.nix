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
    ../apps/polybar
    ../apps/river
    ../apps/rofi
    ../apps/vscode
    ../apps/wofi
    ../apps/swayidle
    ../apps/xmonad
    ../apps/waybar
    ../apps/wob
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Classic";
    size = 48;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = [
    pkgs.etBook
    pkgs.fira
    pkgs.font-awesome
    pkgs.jetbrains-mono
    pkgs.material-icons
    pkgs.material-design-icons
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk
    pkgs.noto-fonts-emoji
    pkgs.roboto
    pkgs.source-sans
    pkgs.vegur
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "NerdFontsSymbolsOnly"];})

    configure-gtk
    pkgs.glib
    pkgs.libnotify

    pkgs.brightnessctl
    pkgs.blueberry
    pkgs.bluez
    pkgs.light
    pkgs.networkmanagerapplet
    pkgs.xclip
    pkgs.wl-clipboard

    # audio
    pkgs.plexamp
    pkgs.pavucontrol
    pkgs.playerctl
    pkgs.wireplumber

    # apps
    pkgs.chromium
    pkgs.cider
    pkgs.firefox-wayland
    pkgs.cinnamon.nemo
    pkgs.remmina
    pkgs.slack
    pkgs.tdesktop
  ];

  systemd.user.startServices = "sd-switch";

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Install.WantedBy = ["graphical-session.target"];
    Unit.PartOf = ["graphical-session.target"];
    Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  systemd.user.services.blueberry-tray = {
    Install.WantedBy = ["graphical-session.target"];
    Unit.PartOf = ["graphical-session.target"];
    Service.ExecStart = "${pkgs.blueberry}/bin/blueberry-tray";
    Service.Type = "forking";
  };

  systemd.user.targets.wayland-session = {
    Unit = {
      Description = "wayland compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };

  systemd.user.targets.xserver-session = {
    Unit = {
      Description = "xserver session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "default-web-browser" = ["firefox.desktop"];
      "text/html" = ["firefox.desktop"];
      "application/pdf" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/about" = ["firefox.desktop"];
      "x-scheme-handler/unknown" = ["firefox.desktop"];
    };
  };
}
