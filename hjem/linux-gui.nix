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

  # home.pointerCursor = {
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Original-Ice";
  #   size = 32;
  #   gtk.enable = true;
  #   x11.enable = true;
  # };

  packages =
    # config.dotfiles.gui.font.fontconfig.fontDirectories
    # ++
    [
      (pkgs.app2unit.overrideAttrs (old: {
        version =
          lib.throwIf (lib.versionAtLeast old.version "1.4.4") "app2unit override can be removed"
            "1.4.4";
        src = pkgs.fetchFromGitHub {
          owner = "Vladimir-csp";
          repo = "app2unit";
          tag = "v1.4.4";
          sha256 = "sha256-TIY+/9ekGub+10uyqXy5aYU+2NLysMtaQnD1PIjBCFA=";
        };

      }))

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

  systemd.services.polkit-agent = {
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig.ExecStart = lib.getExe pkgs.soteria;
  };

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
