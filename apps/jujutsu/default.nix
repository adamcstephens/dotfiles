{ config, pkgs, ... }:
let
  configDir = if pkgs.stdenv.isLinux then ".config/jj" else "Library/Application Support/jj";
in
{
  home.packages = [
    pkgs.jujutsu
    pkgs.watchman
  ];

  home.file."${configDir}/config.toml".source =
    if config.dotfiles.nixosManaged then
      ./config.toml
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/jujutsu/config.toml";
}
