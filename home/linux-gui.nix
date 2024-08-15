{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  configure-gtk = pkgs.writeScriptBin "configure-gtk" (
    let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in
    ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
    ''
  );

  gsettings-wrapper = pkgs.writeScriptBin "gsettings-wrapper" (
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
    ../apps/hyprland
    ../apps/kanshi
    ../apps/river
    ../apps/sleepwatcher-rs
    ../apps/waybar
    ../apps/wob

    # xorg
    ../apps/polybar
    ../apps/xmonad
    ../apps/xorg

    # apps
    ../apps/1password
    ../apps/kitty
    ../apps/mimeapps
    ../apps/ssh
  ];

  dotfiles.apps.emacs.package = pkgs.emacs29-pgtk;

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
    [
      pkgs.python3

      pkgs.etBook
      pkgs.fira
      pkgs.font-awesome
      pkgs.jetbrains-mono
      pkgs.material-icons
      pkgs.material-design-icons
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk
      pkgs.noto-fonts-emoji

      configure-gtk
      gsettings-wrapper
      pkgs.glib
      pkgs.libnotify

      pkgs.brightnessctl
      pkgs.blueberry
      pkgs.bluez
      pkgs.ddcutil
      pkgs.light
      pkgs.networkmanagerapplet

      # audio
      pkgs.pavucontrol
      pkgs.playerctl
      pkgs.wireplumber

      # firefox
      inputs.sandbox.packages.${pkgs.system}.firefox-profile-switcher-connector
      pkgs.firefoxpwa
      (pkgs.firefox-wayland.override {
        nativeMessagingHosts = [
          pkgs.firefoxpwa
          inputs.sandbox.packages.${pkgs.system}.firefox-profile-switcher-connector
        ];
      })

      # apps
      pkgs.cinnamon.nemo
      pkgs.finamp
      pkgs.fractal
      pkgs.eog
      pkgs.hunspell
      pkgs.hunspellDicts.en_US
      pkgs.kid3
      pkgs.libreoffice-fresh
      pkgs.mediainfo
      pkgs.mpv
      pkgs.nmap
      pkgs.remmina
      pkgs.streamrip
      pkgs.thunderbird
      pkgs.yt-dlp

      # bitwarden
      pkgs.pinentry.curses
      pkgs.rofi-rbw

      # nix
      pkgs.nh
      inputs.nix-index-database.packages.${pkgs.system}.nix-index-with-db

      screenshot
    ]
    ++ (lib.optionals config.dotfiles.gui.wayland [
      pkgs.grim
      pkgs.lswt
      pkgs.qt6.qtwayland
      pkgs.slurp
      pkgs.wayshot
      pkgs.wev
      pkgs.wl-clipboard
      pkgs.wl-mirror
      pkgs.wl-screenrec
      pkgs.wlr-randr
      pkgs.wdisplays
      pkgs.wlopm
    ])
    ++ (lib.optionals config.dotfiles.gui.xorg.enable [
      pkgs.arandr
      pkgs.grobi
      pkgs.lxrandr
      pkgs.xclip
      pkgs.xlayoutdisplay
    ])
    ++ (lib.optionals pkgs.stdenv.isx86_64 [ pkgs.simplex-chat-desktop ]);

  programs.feh.enable = true;

  programs.ssh.forwardAgent = true;

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  systemd.user.startServices = "sd-switch";

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit.PartOf = [ "graphical-session.target" ];
    Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
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
      Conflicts = [
        "hyprland-session.target"
        "wayland-session.target"
      ];
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
