{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.kdlfmt
  ];

  xdg.configFile."niri/config.kdl".source =
    if config.dotfiles.nixosManaged then
      ./config.kdl
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/niri/config.kdl";
}
