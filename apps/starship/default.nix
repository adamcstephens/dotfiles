{ dotlib, pkgs, ... }:
{
  home.packages = [ pkgs.starship ];

  smfh.xdg.config.files."starship.toml".source = dotlib.source "apps/starship/starship.toml";
}
