{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
let
  configure-gtk = pkgs.writeShellScriptBin "configure-gtk" (
    let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in
    ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
    ''
  );

  gsettings-wrapper = pkgs.writeShellScriptBin "gsettings-wrapper" (
    let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in
    ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      export gnome_schema=org.gnome.desktop.interface
      gsettings $@
    ''
  );
in
{
  imports = [
    ./gui.nix
    ../apps/noctalia
    ../apps/pinnacle
    ../apps/shikane
    ../apps/wayland

    # desktop env
    # ../apps/ironbar
    # ../apps/niri
    # ../apps/river
    # ../apps/swayidle
    # ../apps/swayosd
    # ../apps/vdirsyncer
    # ../apps/walker

    # apps
    # ../apps/halloy
    # ../apps/kitty
    # ../apps/newsboat
    ../apps/ssh
    # ../apps/todoman

    # HM module users
    # ../apps/dunst
    # ../apps/gammastep
    # ../apps/mimeapps
    # ../apps/rofi
    # ../apps/hypridle
    # ../apps/kanshi
    # ../apps/waybar
  ];

  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #   };
  # };

  dotfiles = {
    apps = {
      # hypridle.enable = lib.mkDefault config.dotfiles.gui.wayland.enable;
      # walker.enable = lib.mkDefault config.dotfiles.gui.wayland.enable;
      # waybar.enable = lib.mkDefault config.dotfiles.gui.wayland.enable;
    };
    gui.wayland.enable = true;
  };

  systemd.services.fc-cache = {
    wantedBy = [ "default.target" ];
    partOf = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.fontconfig}/bin/fc-cache -v";
    restartTriggers = [
      config.xdg.config.files."fontconfig/conf.d/100-hjem.conf".source
    ];
  };

  xdg.config.files."fontconfig/conf.d/100-hjem.conf".text =
    # xml
    ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
        <dir>${config.directory}/.local/state/hjem/standalone/current-profile/share/fonts</dir>
      </fontconfig>
    '';

  # reads fonts from home.packages
  # fonts.fontconfig.enable = true;

  # gtk = {
  #   enable = true;
  #
  #   gtk4.theme = config.gtk.theme;
  #
  #   font = {
  #     name = config.dotfiles.gui.font.variable;
  #     package = pkgs.ibm-plex;
  #     size = 11;
  #   };
  #
  #   iconTheme = {
  #     name = "Flat-Remix-Orange-Dark";
  #     package = pkgs.flat-remix-icon-theme;
  #   };
  #
  #   theme = {
  #     name = "Flat-Remix-GTK-Yellow-Darkest-Solid";
  #     package = pkgs.flat-remix-gtk;
  #   };
  # };

  files.".local/share/icons".source =
    "${config.directory}/.local/state/hjem/standalone/current-profile/share/icons";

  packages =
    config.dotfiles.gui.font.fontconfig.fontDirectories
    ++ [
      pkgs.bibata-cursors

      pkgs.app2unit

      pkgs.et-book
      pkgs.fira
      pkgs.font-awesome
      pkgs.jetbrains-mono
      pkgs.material-icons
      pkgs.material-design-icons

      configure-gtk
      gsettings-wrapper
      pkgs.glib
      pkgs.gtk3 # for gtk-launch
      pkgs.libnotify

      pkgs.brightnessctl
      pkgs.blueman
      pkgs.bluez
      pkgs.ddcutil
      pkgs.networkmanagerapplet

      # audio
      pkgs.nocturne # subsonic
      pkgs.playerctl
      pkgs.pwvucontrol
      pkgs.sone # tidal player
      pkgs.wireplumber

      # firefox
      pkgs.firefox

      # apps
      pkgs.nemo-with-extensions
      pkgs.fractal
      pkgs.eog
      pkgs.hunspell
      pkgs.hunspellDicts.en-us-large
      pkgs.libreoffice-qt6-fresh
      pkgs.mediainfo
      pkgs.mpv
      pkgs.nmap
      pkgs.remmina
      pkgs.signal-desktop

      # bitwarden
      # broken pkgs.bitwarden-desktop
      pkgs.rofi-rbw

      flake.packages.${pkgs.stdenv.hostPlatform.system}.screenshot
    ]
    ++ lib.optionals config.dotfiles.dev.enable [
      # broken 2026-07-10
      # pkgs.jetbrains.datagrip
    ];

  # qt = {
  #   enable = true;
  #   platformTheme.name = "qtct";
  #   style.name = "kvantum";
  # };

  # systemd.startServices = "sd-switch";

  systemd.targets.wayland-session = {
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  # xdg.desktopEntries = {
  #   prj = {
  #     name = "prj";
  #     exec = "/run/current-system/sw/bin/systemd-cat --identifier=prj ${../bin/prj}";
  #   };
  #   reboot = {
  #     name = "reboot";
  #     exec = "/run/current-system/sw/bin/systemctl reboot";
  #   };
  #   screenshot = {
  #     name = "screenshot";
  #     exec = "${lib.getExe flake.packages.${pkgs.stdenv.hostPlatform.system}.screenshot} screen";
  #   };
  #   screenshotBox = {
  #     name = "screenshot box";
  #     exec = "${lib.getExe flake.packages.${pkgs.stdenv.hostPlatform.system}.screenshot} box";
  #   };
  #   screenshotWindow = {
  #     name = "screenshot window";
  #     exec = "${lib.getExe flake.packages.${pkgs.stdenv.hostPlatform.system}.screenshot} window";
  #   };
  # };
}
