{ config, pkgs, ... }:
{
  home.packages = [ pkgs.zellij ];

  home.file.".config/zellij".source =
    if config.dotfiles.nixosManaged then ./. else "${config.home.homeDirectory}/.dotfiles/apps/zellij";
}
