{
  dotlib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.kdlfmt
  ];

  xdg.configFile."niri/config.kdl".source = dotlib.source "apps/niri/config.kdl";
}
