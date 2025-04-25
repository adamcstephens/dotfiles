{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.newsboat
  ];

  xdg.configFile.newsboat.source =
    if config.dotfiles.nixosManaged then
      ./.
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/newsboat";
}
