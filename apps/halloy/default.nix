{ config, pkgs, ... }:
{
  packages = [
    pkgs.halloy
  ];

  files.".config/halloy".source =
    if config.dotfiles.nixosManaged then ./. else "${config.directory}/.dotfiles/apps/halloy";
}
