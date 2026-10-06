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
    "git/config".source = dotlib.source "apps/git/gitconfig";

    "git/ignore".source = dotlib.source "apps/git/ignore";
  };

  xdg.data.files."gh/extensions/gh-stack/gh-stack".source = lib.getExe pkgs.gh-stack;
}
