{
  config,
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
    packages = [ pkgs.tmuxinator ];

    files.".config/tmuxinator".source = config.dotfiles.source "apps/tmuxinator";
  };
}
