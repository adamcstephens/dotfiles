{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.halloy
  ];

  home.file.".config/halloy".source =
    if config.dotfiles.nixosManaged then
      ./.
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/halloy";
}
