{ dotlib, pkgs, ... }:
{
  home.packages = [ pkgs.starship ];

  xdg.configFile."starship.toml".source = dotlib.source "apps/starship/starship.toml";
}
