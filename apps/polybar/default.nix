{
  config,
  lib,
  pkgs,
  ...
}: let
  dependencies = [
    pkgs.bash
    pkgs.playerctl
  ];
  path = "PATH=${config.services.polybar.package}/bin:${lib.makeBinPath dependencies}:/run/wrappers/bin";
in {
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    script = "polybar bar &";

    extraConfig =
      (with config.colorScheme.colors; ''
        [colors]
        background = ${base00}
        background-alt = ${base00}
        foreground = ${base05}
        primary = ${base0A}
        secondary = ${base0C}
        alert = ${base08}
        disabled = ${base03}
        border = ${base03}

        [display]
        dpi = ${toString config.dotfiles.gui.dpi}
        font = ${config.dotfiles.gui.font}:size=9.5;0

        [scripts]
        player = ${./player.sh}
      '')
      + (builtins.readFile ./config.ini);
  };

  systemd.user.services.polybar = {
    Install.WantedBy = lib.mkForce ["xserver-session.target"];
    Unit.PartOf = lib.mkForce ["xserver-session.target"];
    Service.Environment = lib.mkForce path;
  };
}
