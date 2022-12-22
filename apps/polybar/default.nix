{
  config,
  lib,
  pkgs,
  ...
}: {
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

      '')
      + (builtins.readFile ./config.ini);
  };

  systemd.user.services.polybar.Install.WantedBy = lib.mkForce ["xserver-session.target"];
  systemd.user.services.polybar.Unit.PartOf = lib.mkForce ["xserver-session.target"];
}
