{ dotlib, pkgs, ... }:
{
  home.packages = [
    pkgs.todoman
  ];

  xdg.configFile."todoman/config.py".source = dotlib.source "apps/todoman/config.py";
}
