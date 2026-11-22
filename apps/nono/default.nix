{
  dotlib,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.nono
  ];

  smfh.xdg.config.files."nono/profiles".source = dotlib.source "apps/nono/profiles";
}
