{
  config,
  lib,
  pkgs,
  ...
}:
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

  home.sessionVariables = lib.mkIf config.dotfiles.dev.enable {
    GH_TELEMETRY = "false";
  };

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
