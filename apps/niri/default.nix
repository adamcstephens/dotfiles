{
  dotlib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.kdlfmt
  ];

  smfh.xdg.config.files."niri/config.kdl".source = dotlib.source "apps/niri/config.kdl";
}
