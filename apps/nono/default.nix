{
  dotlib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.nono
  ];

  xdg.configFile."nono/profiles".source = dotlib.source "apps/nono/profiles";
}
