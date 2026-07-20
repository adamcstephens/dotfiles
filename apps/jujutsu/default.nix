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
  packages = [
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jujutsu
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.watchman
  ];

  files."${configDir}/config.toml".source =
    if config.dotfiles.nixosManaged then
      ./config.toml
    else
      "${config.directory}/.dotfiles/apps/jujutsu/config.toml";
}
