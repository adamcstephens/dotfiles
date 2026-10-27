{ dotlib, pkgs, ... }:
{
  home.packages = [ pkgs.golden-cheetah ];

  xdg.configFile."goldencheetah.org".source = dotlib.source "apps/goldencheetah";
}
