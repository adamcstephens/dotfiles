{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  skills =
    if config.dotfiles.nixosManaged then
      ./skills
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/agents/skills";

  # AGENTS =
  #   if config.dotfiles.nixosManaged then
  #     ./AGENTS.md
  #   else
  #     config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/agents/AGENTS.md";

  cfg = config.dotfiles.apps.agents;
in
{
  options = {
    dotfiles.apps.agents.enable = lib.mkEnableOption "agent things";
  };

  config = lib.mkIf cfg.enable {
    # unmanage these for epi
    # home.file.".claude/CLAUDE.md".source = AGENTS;
    # home.file.".claude/skills".source = skills;

    home.packages = [
      inputs.vein.packages.${pkgs.stdenv.hostPlatform.system}.vein

      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode
    ];

    home.file.".config/agents/skills".source = skills;
  };
}
