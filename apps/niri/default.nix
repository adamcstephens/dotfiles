{
  config,
  pkgs,
  ...
}:
{
  packages = [
    pkgs.kdlfmt
  ];

  xdg.config.files."niri/config.kdl".source = config.dotfiles.source "apps/niri/config.kdl";
}
