{ dotlib, pkgs, ... }:
{
  home.packages = [
    pkgs.todoman
  ];

  smfh.xdg.config.files."todoman/config.py".source = dotlib.source "apps/todoman/config.py";
}
