{
  dotlib,
  inputs,
  pkgs,
  ...
}:
{
  packages = [
    inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jjui
  ];

  files.".config/jjui/config.toml".source = dotlib.source "apps/jjui/config.toml";
}
