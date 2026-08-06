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
  packages = [
    pkgs.kdlfmt
    package
  ];

  files.".config/zellij/config.kdl".source =
    if config.dotfiles.nixosManaged then
      ./config.kdl
    else
      "${config.directory}/.dotfiles/apps/zellij/config.kdl";

  files.".config/zellij/layouts".source =
    if config.dotfiles.nixosManaged then
      ./layouts
    else
      "${config.directory}/.dotfiles/apps/zellij/layouts";

  files.".config/zellij/themes/moonfly.kdl".source =
    npins.vim-moonfly-colors + "/extras/moonfly-zellij.kdl";

  files.".config/zellij/plugins/vim-zellij-navigator.wasm".source = "${
    flake.packages.${pkgs.stdenv.hostPlatform.system}.vim-zellij-navigator
  }/bin/vim-zellij-navigator.wasm";
}
