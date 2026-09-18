{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  configDir =
    if pkgs.stdenv.hostPlatform.isLinux || (lib.versionAtLeast pkgs.jj.version "0.29.0") then
      ".config/jj"
    else
      "Library/Application Support/jj";
in
{
  packages = [
    inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jujutsu
    pkgs.watchman
  ];

  files."${configDir}/config.toml".source = config.dotfiles.source "apps/jujutsu/config.toml";
}
