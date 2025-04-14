{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.kdlfmt
    pkgs.zellij
  ];

  home.file.".config/zellij".source =
    if config.dotfiles.nixosManaged then
      ./.
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/zellij";
}
