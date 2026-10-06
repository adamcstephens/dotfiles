{ dotlib, pkgs, ... }:
{
  packages = [
    pkgs.todoman
  ];

  xdg.config.files."todoman/config.py".source = dotlib.source "apps/todoman/config.py";
}
