{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.vdirsyncer
  ];

  xdg.configFile."vdirsyncer/config".source =
    if config.dotfiles.nixosManaged then
      ./config
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vdirsyncer/config";
}
