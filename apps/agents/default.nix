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
    "agents/skills".source =
      if config.dotfiles.nixosManaged then
        ./skills
      else
        "${config.directory}/.dotfiles/apps/agents/skills";

    "agents/AGENTS.md".source =
      if config.dotfiles.nixosManaged then
        ./AGENTS.md
      else
        "${config.directory}/.dotfiles/apps/agents/AGENTS.md";
  };
}
