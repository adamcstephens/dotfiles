{
  config,
  dotlib,
  inputs,
  pkgs,
  ...
}:
let
  claude-wrapped = pkgs.symlinkJoin {
    name = "claude-wrapped";
    paths = [ (dotlib.unfreePkg "claude-code" inputs.nixos-unstable-small) ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --set-default CLAUDE_CONFIG_DIR "${config.xdg.configHome}/claude"
    '';
  };
in
{
  home.packages = [
    claude-wrapped
  ];

  home.sessionVariables = {
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
  };

  xdg.configFile = {
    "claude/CLAUDE.md".source = config.xdg.configFile."agents/AGENTS.md".source;
  };
}
