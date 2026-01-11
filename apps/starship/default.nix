{ pkgs, ... }:
{
  home.packages = [ pkgs.starship ];

  xdg.configFile."starship.toml".source = ./starship.toml;
}
