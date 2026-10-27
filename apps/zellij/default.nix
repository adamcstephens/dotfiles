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

  xdg.configFile."zellij/layouts".source = dotlib.source "apps/zellij/layouts";

  xdg.configFile."zellij/config.kdl".source = dotlib.source "apps/zellij/config.kdl";

  xdg.configFile."zellij/themes/moonfly.kdl".source =
    dotlib.source "themes/moonfly/extras/moonfly-zellij.kdl";
}
