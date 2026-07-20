{
  config,
  pkgs,
  ...
}:
{
  packages = [
    pkgs.kdlfmt
  ];

  xdg.config.files."niri/config.kdl".source =
    if config.dotfiles.nixosManaged then
      ./config.kdl
    else
      "${config.directory}/.dotfiles/apps/niri/config.kdl";
}
