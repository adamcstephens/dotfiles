{
  config,
  inputs,
  pkgs,
  ...
}:
let
  skills =
    if config.dotfiles.nixosManaged then
      ./skills
    else
      "${config.directory}/.dotfiles/apps/agents/skills";
in
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
    "agents/skills".source = skills;
  };
}
