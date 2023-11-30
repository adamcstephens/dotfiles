{
  config,
  inputs,
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

  gsettings-wrapper = pkgs.writeScriptBin "gsettings-wrapper" (let
    schema = pkgs.gsettings-desktop-schemas;
    datadir = "${schema}/share/gsettings-schemas/${schema.name}";
  in ''
    export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
    export gnome_schema=org.gnome.desktop.interface
    gsettings $@
  '');

  nix-colors-contrib = inputs.nix-colors.lib-contrib {inherit pkgs;};
in {
  imports = [
    ./core-gui.nix

    # common
    ../apps/dunst
    ../apps/gammastep
    ../apps/rofi

    # wayland
    ../apps/kanshi
    ../apps/river
    ../apps/swayidle
    ../apps/waybar
    ../apps/wob

    # xorg
    ../apps/leftwm
    ../apps/polybar
    ../apps/xmonad
    ../apps/xorg

    # apps
    ../apps/kitty
    ../apps/mimeapps
    ../apps/ssh
    ../apps/vscode
    ../apps/wezterm

    # dev
    ../apps/ghc
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
      name = config.colorScheme.slug;
      package = nix-colors-contrib.gtkThemeFromScheme {
        scheme = config.colorScheme;
      };
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

      # apps
      pkgs.element-desktop
      pkgs.firefox-wayland
      pkgs.cinnamon.nemo
      pkgs.gomuks
      pkgs.libreoffice-fresh
      pkgs.mpv
      pkgs.remmina
      pkgs.thunderbird
      pkgs.webcord

      # bitwarden
      pkgs.pinentry.curses
      pkgs.rbw
      pkgs.rofi-rbw
    ]
    ++ (lib.optionals config.dotfiles.gui.wayland [
      pkgs.grim
      pkgs.slurp
      pkgs.wl-clipboard
      pkgs.wl-mirror
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
    ++ (lib.optionals pkgs.stdenv.isx86_64 [
      pkgs.bitwarden
    ]);

  programs.feh.enable = true;

  programs.ssh.forwardAgent = true;

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
      exec = "/run/current-system/sw/bin/systemd-cat --identifier=screenshot ${../bin/screenshot} screen";
    };
    screenshotBox = {
      name = "screenshot box";
      exec = "/run/current-system/sw/bin/systemd-cat --identifier=screenshot ${../bin/screenshot} box";
    };
    screenshotWindow = {
      name = "screenshot window";
      exec = "/run/current-system/sw/bin/systemd-cat --identifier=screenshot ${../bin/screenshot} window";
    };
  };
}
