{ config, pkgs, ... }:
{
  packages = [
    pkgs.halloy
  ];

  files.".config/halloy".source = config.dotfiles.source "apps/halloy";
}
