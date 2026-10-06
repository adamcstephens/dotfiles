{
  dotlib,
  pkgs,
  ...
}:
{
  packages = [
    pkgs.kdlfmt
  ];

  xdg.config.files."niri/config.kdl".source = dotlib.source "apps/niri/config.kdl";
}
