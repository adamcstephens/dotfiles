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

  files.".config/jjui/config.toml".source =
    if config.dotfiles.nixosManaged then
      ./config.toml
    else
      "${config.directory}/.dotfiles/apps/jjui/config.toml";
}
