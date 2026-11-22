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
    auth =
      lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        serviceAccountTokenFile = "/run/agenix/onenix-agents";
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        desktopAccount = "3F3AGHMXEJGVFBIHSJPY6HN6NE";
      };

    secrets.forgejo-token.reference = "op://Agents/forgejo_token/credential";
  };

  smfh.xdg.config.files = {
    "agents/skills".source = dotlib.source "apps/agents/skills";

    "agents/AGENTS.md".source = dotlib.source "apps/agents/AGENTS.md";
  };
}
