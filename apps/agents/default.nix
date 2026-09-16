{
  config,
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

  packages = [
    pkgs.vikunja.veans
    inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode
  ];

  xdg.config.files = {
    "agents/skills".source = "${config.directory}/.dotfiles/apps/agents/skills";

    "agents/AGENTS.md".source = "${config.directory}/.dotfiles/apps/agents/AGENTS.md";
  };
}
