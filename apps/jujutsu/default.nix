{
  dotlib,
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
  home.packages = [
    inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jujutsu
    pkgs.watchman
  ];

  home.file."${configDir}/config.toml".source = dotlib.source "apps/jujutsu/config.toml";
}
