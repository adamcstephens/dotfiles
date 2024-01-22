{
  config,
  lib,
  pkgs,
  ...
}:
let
  dependencies = [
    pkgs.bash
    pkgs.networkmanagerapplet
    pkgs.pavucontrol
    pkgs.playerctl
  ];

  path = "PATH=${config.services.polybar.package}/bin:${lib.makeBinPath dependencies}:/run/wrappers/bin";
in
{
  config = lib.mkIf config.dotfiles.gui.xorg.enable {
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
          disabled = ${base03}
          border = ${base03}
          red = ${base08}
          green = ${base0B}
          blue = ${base0D}

          [display]
          font-mono = ${config.dotfiles.gui.font.mono}:size=10;0
          font-variable = ${config.dotfiles.gui.font.variable}:size=11;0

          [scripts]
          player = ${./player.sh}
        '')
        + (builtins.readFile ./config.ini);
    };

    systemd.user.services.polybar = {
      Install.WantedBy = lib.mkForce [ "xserver-session.target" ];
      Unit.PartOf = lib.mkForce [ "xserver-session.target" ];
      Service.Environment = lib.mkForce [
        path
        "FONTCONFIG_FILE=${config.dotfiles.gui.font.fontconfig}"
      ];
      Service.RestartSec = "1s";
    };
  };
}
