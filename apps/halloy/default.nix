{ dotlib, pkgs, ... }:
{
  packages = [
    pkgs.halloy
  ];

  files.".config/halloy".source = dotlib.source "apps/halloy";
}
