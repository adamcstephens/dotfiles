{ dotlib, pkgs, ... }:
{
  packages = [ pkgs.starship ];

  xdg.config.files."starship.toml".source = dotlib.source "apps/starship/starship.toml";
}
