{ dotlib, pkgs, ... }:
{
  home.packages = [
    pkgs.newsboat
  ];

  xdg.configFile.newsboat.source = dotlib.source "apps/newsboat";
}
