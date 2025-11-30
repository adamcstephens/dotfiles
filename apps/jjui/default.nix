{
  config,
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jjui
  ];

  home.file.".config/jjui/config.toml".source =
    if config.dotfiles.nixosManaged then
      ./config.toml
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/jjui/config.toml";
}
