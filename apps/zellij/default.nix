{
  config,
  npins,
  pkgs,
  flake,
  ...
}:
let
  package = pkgs.zellij;
in
{
  home.packages = [
    pkgs.kdlfmt
    package
  ];

  home.file.".config/zellij/config.kdl".source =
    if config.dotfiles.nixosManaged then
      ./config.kdl
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/zellij/config.kdl";

  home.file.".config/zellij/layouts".source =
    if config.dotfiles.nixosManaged then
      ./layouts
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/zellij/layouts";

  home.file.".config/zellij/themes/moonfly.kdl".source =
    npins.vim-moonfly-colors + "/extras/moonfly-zellij.kdl";

  home.file.".config/zellij/plugins/vim-zellij-navigator.wasm".source = "${
    flake.packages.${pkgs.stdenv.hostPlatform.system}.vim-zellij-navigator
  }/bin/vim-zellij-navigator.wasm";
}
