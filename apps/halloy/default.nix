{ dotlib, pkgs, ... }:
{
  home.packages = [
    pkgs.halloy
  ];

  xdg.configFile."halloy".source = dotlib.source "apps/halloy";
}
