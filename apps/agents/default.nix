{
  dotlib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../agent-browser
    ../claude
    ../codex
    ../nono
    ../omp
    ../pi
  ];

  home.packages = [
    pkgs.vikunja.veans
    inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode
  ];

  xdg.configFile = {
    "agents/skills".source = dotlib.source "apps/agents/skills";

    "agents/AGENTS.md".source = dotlib.source "apps/agents/AGENTS.md";
  };
}
