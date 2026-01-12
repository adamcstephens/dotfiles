{
  config,
  lib,
  pkgs,
  ...
}:
let
  os = pkgs.stdenv.hostPlatform.uname.system;
in
{
  home.packages = [
    pkgs.git
    pkgs.git-extras
  ]
  ++ lib.optionals config.dotfiles.dev.enable [
    pkgs.gh
    pkgs.lazygit
    (pkgs.writeShellScriptBin "lg" "exec ${lib.getExe pkgs.lazygit} $@")
    pkgs.forgejo-cli
  ];

  xdg.configFile = {
    "git/config".source =
      if config.dotfiles.nixosManaged then
        ./gitconfig
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/git/gitconfig";

    "git/ignore".source =
      if config.dotfiles.nixosManaged then
        ./ignore
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/git/ignore";
  };
}
