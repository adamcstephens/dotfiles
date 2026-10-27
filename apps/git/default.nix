{
  config,
  dotlib,
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
  home.packages = [
    pkgs.git
    pkgs.git-extras
  ]
  ++ lib.optionals config.dotfiles.dev.enable [
    gh
    pkgs.lazygit
    (pkgs.writeShellScriptBin "lg" "exec ${lib.getExe pkgs.lazygit} $@")
    pkgs.forgejo-cli
    pkgs.tea
  ];

  xdg.configFile = {
    "git/config".source = dotlib.source "apps/git/gitconfig";

    "git/ignore".source = dotlib.source "apps/git/ignore";
  };

  xdg.dataFile."gh/extensions/gh-stack/gh-stack".source = lib.getExe pkgs.gh-stack;
}
