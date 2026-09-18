{
  config,
  inputs,
  pkgs,
  ...
}:
{
  packages = [
    inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jjui
  ];

  files.".config/jjui/config.toml".source = config.dotfiles.source "apps/jjui/config.toml";
}
