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
    # actual gui apps
    ../apps/dunst
    # ../apps/eww
    ../apps/gammastep
    ../apps/hyprland
    ../apps/kanshi
    ../apps/kitty
    ../apps/polybar
    ../apps/river
    ../apps/rofi
    ../apps/ssh
    ../apps/vscode
    ../apps/wofi
    ../apps/swayidle
    ../apps/xmonad
    ../apps/waybar
    ../apps/wob

    # dev
    ../apps/ghc
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
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

  home.activation.fix-mimeapps = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -h "${config.home.homeDirectory}/.config/mimeapps.list" ]; then
      rm -fv "${config.home.homeDirectory}/.config/mimeapps.list"
    fi
  '';

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.macchiatoDark;
    name = "Catppuccin-Macchiato-Dark-Cursors";
    size = 48;
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
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "NerdFontsSymbolsOnly"];})

      configure-gtk
      pkgs.glib
      pkgs.libnotify

      pkgs.autorandr
      pkgs.brightnessctl
      pkgs.blueberry
      pkgs.bluez
      pkgs.ddcutil
      pkgs.light
      pkgs.lxrandr
      pkgs.networkmanagerapplet
      pkgs.wl-clipboard
      pkgs.xclip
      pkgs.xlayoutdisplay

      # audio
      pkgs.pavucontrol
      pkgs.playerctl
      pkgs.wireplumber

      # apps
      pkgs.chromium
      pkgs.element-desktop
      pkgs.firefox-wayland
      pkgs.cinnamon.nemo
      pkgs.remmina

      # dev (too heavy for core)
      pkgs.nodePackages.bash-language-server

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
      pkgs.cinny-desktop
      pkgs.tdesktop
    ]);

  programs.feh.enable = true;

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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["firefox.desktop"];
      "application/x-extension-htm" = ["firefox.desktop"];
      "application/x-extension-html" = ["firefox.desktop"];
      "application/x-extension-shtml" = ["firefox.desktop"];
      "application/x-extension-xht" = ["firefox.desktop"];
      "application/x-extension-xhtml" = ["firefox.desktop"];
      "application/xhtml+xml" = ["firefox.desktop"];
      "default-web-browser" = ["firefox.desktop"];
      "image/png" = ["feh.desktop"];
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/about" = ["firefox.desktop"];
      "x-scheme-handler/chrome" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };
  };
}