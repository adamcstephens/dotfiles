{ config, pkgs, ... }:
{
  packages = [
    pkgs.vdirsyncer
  ];

  xdg.config.files."vdirsyncer/config".source =
    if config.dotfiles.nixosManaged then
      ./config
    else
      "${config.directory}/.dotfiles/apps/vdirsyncer/config";
}
