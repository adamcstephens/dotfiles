{
  config,
  npins,
  pkgs,
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

  xdg.config.files."zellij/config.kdl".source =
    if config.dotfiles.nixosManaged then
      ./config.kdl
    else
      "${config.directory}/.dotfiles/apps/zellij/config.kdl";

  xdg.config.files."zellij/themes".source =
    if config.dotfiles.nixosManaged then
      ./themes
    else
      "${config.directory}/.dotfiles/apps/zellij/themes";

  xdg.config.files."zellij/themes/moonfly.kdl".source =
    npins.vim-moonfly-colors + "/extras/moonfly-zellij.kdl";

  xdg.config.files."zellij/plugins/vim-zellij-navigator.wasm".source =
    pkgs.zellijPlugins.vim-zellij-navigator;
}
