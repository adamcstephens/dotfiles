{ config, pkgs, ... }:
{
  packages = [ pkgs.starship ];

  xdg.config.files."starship.toml".source =
    if config.dotfiles.nixosManaged then
      ./starship.toml
    else
      "${config.directory}/.dotfiles/apps/starship/starship.toml";
}
