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

  nix-colors-contrib = inputs.nix-colors.lib-contrib {inherit pkgs;};
in {
  imports = [
    # common
    ../apps/dunst
    ../apps/gammastep

    # wayland
    ../apps/kanshi
    ../apps/river
    ../apps/swayidle
    ../apps/waybar
    ../apps/wob
    ../apps/wofi

    # xorg
    # ../apps/leftwm
    ../apps/polybar
    ../apps/rofi
    ../apps/xmonad

    # apps
    ../apps/kitty
    ../apps/mimeapps
    ../apps/ssh
    ../apps/vscode
    ../apps/wezterm

    # dev
    ../apps/ghc
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;

    font = {
      name = "SF Pro Display";
      package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro;
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
      pkgs.manrope
      pkgs.material-icons
      pkgs.material-design-icons
      pkgs.merriweather
      pkgs.norwester-font
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk
      pkgs.noto-fonts-emoji
      pkgs.roboto
      inputs.apple-fonts.packages.${pkgs.system}.sf-mono
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro
      pkgs.source-sans
      pkgs.vegur

      configure-gtk
      pkgs.glib
      pkgs.libnotify

      pkgs.brightnessctl
      pkgs.blueberry
      pkgs.bluez
      pkgs.ddcutil
      pkgs.light
      pkgs.networkmanagerapplet

      # xorg
      pkgs.autorandr
      pkgs.lxrandr
      pkgs.xclip
      pkgs.xlayoutdisplay

      # wayland
      pkgs.grim
      pkgs.slurp
      pkgs.wl-clipboard

      # audio
      pkgs.pavucontrol
      pkgs.playerctl
      pkgs.wireplumber

      # apps
      pkgs.chromium
      pkgs.element-desktop
      pkgs.firefox-wayland
      pkgs.cinnamon.nemo
      pkgs.gomuks
      pkgs.libreoffice-fresh
      pkgs.mpv
      pkgs.remmina
      pkgs.thunderbird

      # wrap webcord to remove state file https://github.com/SpacingBat3/WebCord/issues/360
      (pkgs.symlinkJoin {
        name = "webcord-wrapper";
        nativeBuildInputs = [pkgs.makeWrapper];
        paths = [
          pkgs.webcord
        ];
        postBuild = ''
          wrapProgram "$out/bin/webcord" --run 'rm -f $HOME/.config/WebCord/windowState.json'
        '';
      })
    ]
    ++ (lib.optionals pkgs.stdenv.isx86_64 [
      # pkgs.cinny-desktop
      pkgs.slack
      pkgs.tdesktop
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
