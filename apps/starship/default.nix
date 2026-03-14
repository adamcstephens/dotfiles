{ config, pkgs, ... }:
{
  home.packages = [ pkgs.starship ];

  xdg.configFile."starship.toml".source =
    if config.dotfiles.nixosManaged then
      ./starship.toml
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/starship/starship.toml";
}
