{
  config,
  inputs',
  lib,
  pkgs,
  ...
}: let
  graphicalWantedBy = ["river-session.target"];

  apps = {
    way-displays = {
      home.packages = [
        pkgs.way-displays
      ];

      systemd.user.services.way-displays = {
        Unit = {
          Description = "way-displays";
          Documentation = ["man:way-displays(1)"];
        };

        Service = {
          ExecStart = "${pkgs.way-displays}/bin/way-displays";
        };

        Install = {
          WantedBy = graphicalWantedBy;
        };
      };
    };
  };
in {
  imports = [
    ../apps/eww

    apps.way-displays
  ];

  fonts.fontconfig.enable = true;

  home.packages = [
    # pkgs.cider
    pkgs.material-design-icons
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})

    pkgs.bluez
    pkgs.light
    pkgs.networkmanagerapplet

    # audio
    pkgs.wireplumber

    # apps
    inputs'.webcord.packages.default
  ];

  programs.doom-emacs = {
    emacsPackage = pkgs.emacsPgtkNativeComp;
  };

  home.activation.dotfiles-bootstrap-linux-gui = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    pushd ~/.dotfiles
      CONFIG=dotbot.linux-gui.yaml task dotbot
    popd
  '';

  systemd.user.startServices = "sd-switch";
}
