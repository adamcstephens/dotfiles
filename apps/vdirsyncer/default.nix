{ dotlib, pkgs, ... }:
{
  home.packages = [
    pkgs.vdirsyncer
  ];

  smfh.xdg.config.files."vdirsyncer/config".source = dotlib.source "apps/vdirsyncer/config";
}
