{ dotlib, pkgs, ... }:
{
  home.packages = [
    pkgs.vdirsyncer
  ];

  xdg.configFile."vdirsyncer/config".source = dotlib.source "apps/vdirsyncer/config";
}
