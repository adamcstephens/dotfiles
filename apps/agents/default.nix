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

  # helper to drop unfree licenses
  unfreePkg =
    name: nixpkgs:
    nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.${name}.overrideAttrs (old: {
      meta = old.meta // {
        license = [ ];
      };
    });
in
{
  options = {
    dotfiles.apps.agents.enable = lib.mkEnableOption "agent things";
  };

  config = lib.mkIf cfg.enable {
    # unmanage these for epi
    # home.file.".claude/CLAUDE.md".source = AGENTS;
    # home.file.".claude/skills".source = skills;

    home.sessionVariables = {
      CLAUDE_CONFIG_DIR = "${config.home.homeDirectory}/.config/claude";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      AGENT_BROWSER_EXECUTABLE_PATH = lib.getExe pkgs.chromium;
    };

    home.packages = [
      inputs.vein.packages.${pkgs.stdenv.hostPlatform.system}.vein

      (unfreePkg "claude-code" inputs.nixpkgs-unstable-small)
      (unfreePkg "github-copilot-cli" inputs.nixpkgs-unstable-small)

      inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.agent-browser
      inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode
    ];

    home.file.".config/agents/skills".source = skills;
  };
}
