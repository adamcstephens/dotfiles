{ config, pkgs, ... }:
{
  packages = [
    pkgs.todoman
  ];

  xdg.config.files."todoman/config.py".source =
    if config.dotfiles.nixosManaged then
      ./config.py
    else
      "${config.directory}/.dotfiles/apps/todoman/config.py";
}
