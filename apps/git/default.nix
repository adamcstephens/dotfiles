{
  config,
  dotlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../gh
  ];

  home.packages = [
    pkgs.git
    pkgs.git-extras
  ]
  ++ lib.optionals config.dotfiles.dev.enable [
    pkgs.lazygit
    (pkgs.writeShellScriptBin "lg" "exec ${lib.getExe pkgs.lazygit} $@")
    pkgs.forgejo-cli
    pkgs.tea
  ];

  xdg.configFile = {
    "git/config".source = dotlib.source "apps/git/gitconfig";
    "git/ignore".source = dotlib.source "apps/git/ignore";
  };
}
