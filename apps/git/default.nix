{
  config,
  lib,
  pkgs,
  ...
}:
let
  gh = pkgs.symlinkJoin {
    name = "gh-wrapped";
    paths = [ pkgs.gh ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/gh \
        --set GH_TELEMETRY false
    '';
  };
in
{
  packages = [
    pkgs.git
    pkgs.git-extras
  ]
  ++ lib.optionals config.dotfiles.dev.enable [
    pkgs.gh
    pkgs.lazygit
    (pkgs.writeShellScriptBin "lg" "exec ${lib.getExe pkgs.lazygit} $@")
    pkgs.forgejo-cli
  ];

  xdg.config.files = {
    "git/config".source =
      if config.dotfiles.nixosManaged then
        ./gitconfig
      else
        "${config.directory}/.dotfiles/apps/git/gitconfig";

    "git/ignore".source =
      if config.dotfiles.nixosManaged then ./ignore else "${config.directory}/.dotfiles/apps/git/ignore";
  };
}
