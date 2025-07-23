{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.hyprlock
  ];

  xdg.configFile."hypr/hyprlock.conf".source =
    if config.dotfiles.nixosManaged then
      ./hyprlock.conf
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/hyprlock/hyprlock.conf";
}
