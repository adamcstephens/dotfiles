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
    home.packages = [ pkgs.tmuxinator ];

    home.file.".config/tmuxinator".source =
      if config.dotfiles.nixosManaged then
        ./.
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/tmuxinator";
  };
}
