{ config, pkgs, ... }:
{
  packages = [
    pkgs.newsboat
  ];

  xdg.config.files.newsboat.source = config.dotfiles.source "apps/newsboat";
}
