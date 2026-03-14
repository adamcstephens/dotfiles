{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    inputs.epi.packages.${pkgs.stdenv.hostPlatform.system}.epi
  ];

  xdg.configFile."epi".source =
    if config.dotfiles.nixosManaged then
      ./.
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/epi";
}
