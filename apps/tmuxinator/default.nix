{
  config,
  dotlib,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.tmuxinator;
in
{
  options.dotfiles.apps.tmuxinator = {
    enable = lib.mkEnableOption "tmuxinator";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.tmuxinator ];

    xdg.configFile."tmuxinator".source = dotlib.source "apps/tmuxinator";
  };
}
