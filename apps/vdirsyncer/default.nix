{ dotlib, pkgs, ... }:
{
  packages = [
    pkgs.vdirsyncer
  ];

  xdg.config.files."vdirsyncer/config".source = dotlib.source "apps/vdirsyncer/config";
}
