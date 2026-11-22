{ dotlib, pkgs, ... }:
{
  home.packages = [
    pkgs.halloy
  ];

  smfh.xdg.config.files."halloy".source = dotlib.source "apps/halloy";
}
