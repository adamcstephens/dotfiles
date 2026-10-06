{ dotlib, pkgs, ... }:
{
  packages = [
    pkgs.newsboat
  ];

  xdg.config.files.newsboat.source = dotlib.source "apps/newsboat";
}
