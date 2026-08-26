{
  config,
  inputs,
  lib,
  pkgs,
  flake,
  ...
}:
let
  skills =
    if config.dotfiles.nixosManaged then
      ./skills
    else
      "${config.directory}/.dotfiles/apps/agents/skills";

  cfg = config.dotfiles.apps.agents;

  # helper to drop unfree licenses
  unfreePkg =
    name: nixpkgs:
    nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.${name}.overrideAttrs (old: {
      meta = old.meta // {
        license = [ ];
      };
    });

  claude-wrapped = pkgs.symlinkJoin {
    name = "claude-wrapped";
    paths = [ (unfreePkg "claude-code" inputs.nixos-unstable-small) ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --set-default CLAUDE_CONFIG_DIR "${config.directory}/.config/claude"
    '';
  };

  agent-browser = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.agent-browser;

  agent-browser-wrapped =
    if pkgs.stdenv.hostPlatform.isLinux then
      pkgs.symlinkJoin {
        name = "agent-browser-wrapped";
        paths = [ agent-browser ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/agent-browser \
            --set-default AGENT_BROWSER_EXECUTABLE_PATH "${lib.getExe pkgs.chromium}"
        '';
      }
    else
      agent-browser;
in
{
  imports = [
    ../nono
    ../pi
  ];

  options = {
    dotfiles.apps.agents.enable = lib.mkEnableOption "agent things";
  };

  config = lib.mkIf cfg.enable {
    packages = [
      inputs.vein.packages.${pkgs.stdenv.hostPlatform.system}.vein
      pkgs.vikunja.veans

      agent-browser-wrapped
      claude-wrapped
      inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode
      (unfreePkg "github-copilot-cli" inputs.nixos-unstable-small)
    ];

    xdg.config.files = {
      "agents/skills".source = skills;
    };

    environment.sessionVariables = {
      CLAUDE_CONFIG_DIR = "${config.directory}/.config/claude";
    };
  };
}
