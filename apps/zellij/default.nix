{
  config,
  npins,
  pkgs,
  ...
}:
let
  package = pkgs.zellij.override {
    extraPackages = [
      pkgs.zellijPlugins.vim-zellij-navigator
    ];
  };
in
{
  packages = [
    pkgs.kdlfmt
    package
  ];

  xdg.config.files."zellij/layouts".source =
    if config.dotfiles.nixosManaged then
      ./layouts
    else
      "${config.directory}/.dotfiles/apps/zellij/layouts";

  xdg.config.files."zellij/config.kdl".source =
    if config.dotfiles.nixosManaged then
      ./config.kdl
    else
      "${config.directory}/.dotfiles/apps/zellij/config.kdl";

  xdg.config.files."zellij/themes/moonfly.kdl".source =
    npins.vim-moonfly-colors + "/extras/moonfly-zellij.kdl";
}
