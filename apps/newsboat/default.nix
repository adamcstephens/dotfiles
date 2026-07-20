{ config, pkgs, ... }:
{
  packages = [
    pkgs.newsboat
  ];

  xdg.config.files.newsboat.source =
    if config.dotfiles.nixosManaged then ./. else "${config.directory}/.dotfiles/apps/newsboat";
}
