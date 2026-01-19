{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.todoman
  ];

  xdg.configFile."todoman/config.py".source =
    if config.dotfiles.nixosManaged then
      ./config.py
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/todoman/config.py";
}
