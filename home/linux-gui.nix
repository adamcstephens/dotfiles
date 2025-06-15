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

  screenshot = pkgs.callPackage ../packages/screenshot.nix { };
in
{
  imports = [
    ./core-gui.nix

    # common
    ../apps/dunst
    ../apps/gammastep
    ../apps/rofi

    # wayland
    ../apps/hypridle
    ../apps/kanshi
    ../apps/ironbar
    ../apps/niri
    ../apps/river
    ../apps/sleepwatcher-rs
    ../apps/swayidle
    ../apps/swayosd
    ../apps/waybar

    # xorg
    ../apps/polybar
    ../apps/xmonad
    ../apps/xorg

    # apps
    ../apps/1password
    ../apps/kitty
    ../apps/mimeapps
    ../apps/newsboat
    ../apps/ssh
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  dotfiles.apps = {
    hypridle.enable = lib.mkDefault config.dotfiles.gui.wayland.enable;
    ironbar.enable = lib.mkDefault config.dotfiles.gui.wayland.enable;
  };

  # reads fonts from home.packages
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;

    font = {
      name = config.dotfiles.gui.font.variable;
      package = pkgs.ibm-plex;
      size = 11;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Ice";
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages =
    config.dotfiles.gui.font.fontconfig.fontDirectories
    ++ [
      pkgs.etBook
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
      pkgs.blueberry
      pkgs.bluez
      pkgs.ddcutil
      pkgs.light
      pkgs.networkmanagerapplet

      # audio
      pkgs.playerctl
      pkgs.pwvucontrol
      pkgs.wireplumber

      # firefox
      pkgs.firefox-wayland

      # apps
      pkgs.nemo
      pkgs.finamp
      pkgs.fractal
      pkgs.eog
      pkgs.hunspell
      pkgs.hunspellDicts.en-us-large
      pkgs.kid3
      pkgs.libreoffice-qt6-fresh
      pkgs.mediainfo
      pkgs.mpv
      pkgs.nmap
      pkgs.remmina
      pkgs.thunderbird
      pkgs.ungoogled-chromium
      pkgs.yt-dlp

      # bitwarden
      pkgs.rofi-rbw

      screenshot
    ]
    ++ lib.optionals config.dotfiles.nixosManaged [
      flake.packages.${pkgs.system}.rofi-wrapper
    ]
    ++ lib.optionals config.dotfiles.dev.enable [
      pkgs.jetbrains.datagrip
    ];

  programs.feh.enable = true;

  programs.ssh.forwardAgent = true;

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  systemd.user.startServices = "sd-switch";

  systemd.user.services.polkit-agent = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit.PartOf = [ "graphical-session.target" ];
    Service.ExecStart = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
  };

  systemd.user.services.blueberry-tray = {
    Install.WantedBy = [ "xserver-session.target" ];
    Unit.PartOf = [ "xserver-session.target" ];
    Service.ExecStart = "${pkgs.blueberry}/bin/blueberry-tray";
    Service.Type = "forking";
  };

  systemd.user.targets.wayland-session = {
    Unit = {
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
      Conflicts = [ "xserver-session.target" ];
    };
  };

  systemd.user.targets.xserver-session = {
    Unit = {
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
      Conflicts = [ config.wayland.systemd.target ];
    };
  };

  xdg.configFile."firefoxprofileswitcher/config.json".text = builtins.toJSON {
    browser_binary = "${config.home.profileDirectory}/bin/firefox";
  };

  xdg.desktopEntries = {
    prj = {
      name = "prj";
      exec = "/run/current-system/sw/bin/systemd-cat --identifier=prj ${../bin/prj}";
    };
    reboot = {
      name = "reboot";
      exec = "/run/current-system/sw/bin/systemctl reboot";
    };
    screenshot = {
      name = "screenshot";
      exec = "/run/current-system/sw/bin/systemd-cat --identifier=screenshot ${lib.getExe screenshot} screen";
    };
    screenshotBox = {
      name = "screenshot box";
      exec = "/run/current-system/sw/bin/systemd-cat --identifier=screenshot ${lib.getExe screenshot} box";
    };
    screenshotWindow = {
      name = "screenshot window";
      exec = "/run/current-system/sw/bin/systemd-cat --identifier=screenshot ${lib.getExe screenshot} window";
    };
  };
}
