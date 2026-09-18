{ config, pkgs, ... }:
{
  packages = [ pkgs.starship ];

  xdg.config.files."starship.toml".source = config.dotfiles.source "apps/starship/starship.toml";
}
