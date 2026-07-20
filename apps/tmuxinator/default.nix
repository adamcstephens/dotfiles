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

    files.".config/tmuxinator".source =
      if config.dotfiles.nixosManaged then ./. else "${config.directory}/.dotfiles/apps/tmuxinator";
  };
}
