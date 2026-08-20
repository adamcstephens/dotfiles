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

  files.".config/zellij".source =
    if config.dotfiles.nixosManaged then ./. else "${config.directory}/.dotfiles/apps/zellij";

  files.".config/zellij/themes/moonfly.kdl".source =
    npins.vim-moonfly-colors + "/extras/moonfly-zellij.kdl";

  files.".config/zellij/plugins/vim-zellij-navigator.wasm".source = "${
    flake.packages.${pkgs.stdenv.hostPlatform.system}.vim-zellij-navigator
  }/bin/vim-zellij-navigator.wasm";
}
