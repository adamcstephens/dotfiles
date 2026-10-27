{
  config,
  dotlib,
  pkgs,
  ...
}:
let
  codex-wrapped = pkgs.symlinkJoin {
    name = "codex-wrapped";
    paths = [
      pkgs.codex
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/codex \
        --set-default CODEX_HOME "${config.xdg.configHome}/codex"
    '';
  };
in
{
  home.packages = [
    codex-wrapped
  ];

  xdg.configFile = {
    "codex/AGENTS.md".source = config.xdg.configFile."agents/AGENTS.md".source;
    "codex/hooks.json".source = dotlib.source "apps/codex/hooks.json";
    "codex/rules".source = dotlib.source "apps/codex/rules";
    "codex/skills".source = config.xdg.configFile."agents/skills".source;
  };
}
