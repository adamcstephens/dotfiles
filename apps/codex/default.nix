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

  xdg.config.files = {
    "codex/AGENTS.md".source = config.xdg.config.files."agents/AGENTS.md".source;
    "codex/hooks.json".source = "${config.directory}/.dotfiles/apps/codex/hooks.json";
    "codex/rules".source = "${config.directory}/.dotfiles/apps/codex/rules";
    "codex/skills".source = config.xdg.config.files."agents/skills".source;
  };
}
