{ config, ... }:
{
  xdg.configFile."hypr/hyprland.conf".source =
    if config.dotfiles.nixosManaged then
      ./hyprland.conf
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/hyprland/hyprland.conf";
}
