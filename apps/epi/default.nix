{
  config,
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    inputs.epi.packages.${pkgs.stdenv.hostPlatform.system}.epi
  ];

  xdg.configFile."epi".source =
    if config.dotfiles.nixosManaged then
      ./.
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/epi";
}
