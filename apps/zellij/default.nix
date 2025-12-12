{
  config,
  npins,
  pkgs,
  flake,
  ...
}:
{
  home.packages = [
    pkgs.kdlfmt
    (pkgs.zellij.overrideAttrs {
      patches = [
        (pkgs.fetchpatch2 {
          url = "https://github.com/Enzime/zellij/commit/60acd439985339e518f090821c0e4eb366ce6014.patch?full_index=1";
          hash = "sha256-pCFDEbgceNzZAjxSXme/nQ4iQc8qNw2IOMtec16cr8k=";
        })
      ];
    })
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
