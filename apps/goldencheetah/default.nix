{
  config,
  inputs',
  pkgs,
  ...
}: {
  home.packages = [
    # pkgs.golden-cheetah
    inputs'.nixpkgs-gc.legacyPackages.golden-cheetah
  ];

  home.file.".config/goldencheetah.org".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/goldencheetah";
}
