{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  configDir =
    if pkgs.stdenv.isLinux || (lib.versionAtLeast pkgs.jj.version "0.29.0") then
      ".config/jj"
    else
      "Library/Application Support/jj";
in
{
  home.packages = [
    inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jujutsu
    pkgs.watchman
  ];

  home.file."${configDir}/config.toml".source =
    if config.dotfiles.nixosManaged then
      ./config.toml
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/jujutsu/config.toml";
}
