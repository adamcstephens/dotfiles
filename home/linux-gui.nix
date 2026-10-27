{
  config,
  dotlib,
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
    ../apps/mimeapps
    ../apps/noctalia
    # ../apps/pinnacle
    ../apps/river
    ../apps/shikane
    ../apps/umbriel
    ../apps/wayland

    # desktop env
    # ../apps/ironbar
    # ../apps/niri
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
    # ../apps/rofi
    # ../apps/hypridle
    # ../apps/kanshi
    # ../apps/waybar
  ];

  dotfiles = {
    gui.wayland.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      name = config.dotfiles.gui.font.variable;
      size = 11;
      package = pkgs.ibm-plex;
    };
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = true";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  systemd.user.services.fc-cache = {
    Unit = {
      PartOf = [ "default.target" ];
      X-Restart-Triggers = [
        config.xdg.configFile."fontconfig/conf.d/100-home-manager.conf".source
      ];
    };
    Service.ExecStart = "${pkgs.fontconfig}/bin/fc-cache -v";
    Install.WantedBy = [ "default.target" ];
  };

  xdg.configFile."fontconfig/conf.d/100-home-manager.conf".text =
    # xml
    ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
        <dir>${config.home.profileDirectory}/share/fonts</dir>
      </fontconfig>
    '';

  home.file.".local/share/icons".source =
    (pkgs.buildEnv {
      name = "icons";
      paths = [
        pkgs.bibata-cursors
      ];
    })
    + "/share/icons";

  home.packages =
    config.dotfiles.gui.font.fontconfig.fontDirectories
    ++ [
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
      # from nixos for polkit pkgs.bitwarden-desktop
      pkgs.rofi-rbw

      flake.packages.${pkgs.stdenv.hostPlatform.system}.screenshot

      flake.packages.${pkgs.stdenv.hostPlatform.system}.tern-wrapper
    ]
    ++ lib.optionals config.dotfiles.dev.enable [
      (dotlib.unfreePkg [ "jetbrains" "datagrip" ] pkgs)
    ];

  systemd.user.targets.wayland-session.Unit = {
    BindsTo = [ "graphical-session.target" ];
    Wants = [ "graphical-session-pre.target" ];
    After = [ "graphical-session-pre.target" ];
  };
}
