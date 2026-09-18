{ config, pkgs, ... }:
{
  packages = [
    pkgs.todoman
  ];

  xdg.config.files."todoman/config.py".source = config.dotfiles.source "apps/todoman/config.py";
}
