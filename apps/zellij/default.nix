{
  dotlib,
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
  home.packages = [
    pkgs.kdlfmt
    package
  ];

  smfh.xdg.config.files."zellij/layouts".source = dotlib.source "apps/zellij/layouts";

  smfh.xdg.config.files."zellij/config.kdl".source = dotlib.source "apps/zellij/config.kdl";

  smfh.xdg.config.files."zellij/themes/moonfly.kdl".source =
    dotlib.source "themes/moonfly/extras/moonfly-zellij.kdl";
}
