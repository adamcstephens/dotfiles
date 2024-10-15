{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.jujutsu
  ];

  xdg.configFile."jj/config.toml".source =
    if config.dotfiles.nixosManaged then
      ./config.toml
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/jujutsu/config.toml";
}
