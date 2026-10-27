{
  dotlib,
  pkgs,
  ...
}:
{
  imports = [
    ../agent-browser
    ../claude
    ../codex
    ../nono
    ../opencode
    ../omp
    ../pi
  ];

  home.packages = [
    pkgs.vikunja.veans
  ];

  xdg.configFile = {
    "agents/skills".source = dotlib.source "apps/agents/skills";

    "agents/AGENTS.md".source = dotlib.source "apps/agents/AGENTS.md";
  };
}
