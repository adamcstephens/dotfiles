{ dotlib, pkgs, ... }:
{
  home.packages = [
    pkgs.newsboat
  ];

  smfh.xdg.config.files.newsboat.source = dotlib.source "apps/newsboat";
}
