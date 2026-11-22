{
  config,
  dotlib,
  inputs,
  pkgs,
  ...
}:
let
  codex-wrapped = pkgs.symlinkJoin {
    name = "codex-wrapped";
    paths = [
      inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.codex
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

  smfh.xdg.config.files = {
    "codex/AGENTS.md".source = config.smfh.xdg.config.files."agents/AGENTS.md".source;
    "codex/hooks.json".source = dotlib.source "apps/codex/hooks.json";
    "codex/rules".source = dotlib.source "apps/codex/rules";
    "codex/skills".source = config.smfh.xdg.config.files."agents/skills".source;
  };
}
