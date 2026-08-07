{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.agents;
in
{
  config = lib.mkIf cfg.enable {
    packages = [
      pkgs.nono
    ];

    xdg.config.files."nono/profiles".source =
      if config.dotfiles.nixosManaged then
        ./profiles
      else
        "${config.directory}/.dotfiles/apps/nono/profiles";
  };
}
