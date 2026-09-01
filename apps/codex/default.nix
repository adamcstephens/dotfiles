{ config, pkgs, ... }:
let
  codex-wrapped = pkgs.symlinkJoin {
    name = "codex-wrapped";
    paths = [
      pkgs.codex
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/codex \
        --set-default CODEX_HOME "${config.directory}/.config/codex"
    '';
  };
in
{
  packages = [
    codex-wrapped
  ];
}
