{ config, pkgs, ... }:
{
  packages = [
    pkgs.vdirsyncer
  ];

  xdg.config.files."vdirsyncer/config".source = config.dotfiles.source "apps/vdirsyncer/config";
}
