{
  dotlib,
  pkgs,
  ...
}:
{
  packages = [
    pkgs.nono
  ];

  xdg.config.files."nono/profiles".source = dotlib.source "apps/nono/profiles";
}
