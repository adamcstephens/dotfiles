{
  dotlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../agent-browser
    ../claude
    ../codex
    ../nono
    # ../opencode
    ../omp
    ../pi
  ];

  home.packages = [
    pkgs.vikunja.veans
  ];

  onenix = {
    enable = lib.mkDefault true;
    auth.serviceAccountTokenFile = "/run/agenix/onenix-agents";
    secrets.forgejo-token.reference = "op://Agents/forgejo_token/credential";
  };

  xdg.configFile = {
    "agents/skills".source = dotlib.source "apps/agents/skills";

    "agents/AGENTS.md".source = dotlib.source "apps/agents/AGENTS.md";
  };
}
