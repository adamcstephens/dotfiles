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

  pi-extensions = pkgs.importNpmLock.buildNodeModules {
    npmRoot = ./pi;
    nodejs = pkgs.nodejs;
  };

  pi-coding-agent-wrapped = pkgs.symlinkJoin {
    name = "pi-coding-agent-wrapped";
    paths = [
      inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pi-coding-agent
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/pi \
        --set-default PI_CODING_AGENT_DIR "${config.directory}/.config/pi/agent" \
        --set-default PI_OFFLINE true \
        --set-default PI_TELEMETRY true \
        --set-default PI_LENS_HOME "${config.directory}/.config/pi/pi-lens" \
        --set-default PI_LENS_CONFIG_PATH "${config.directory}/.config/pi/pi-lens/config.json" \
        --set-default PILENS_DATA_DIR "${config.directory}/.config/pi/pi-lens/projects"
    '';
  };
in
{
  imports = [
    ../nono
  ];

  options = {
    dotfiles.apps.agents.enable = lib.mkEnableOption "agent things";
  };

  config = lib.mkIf cfg.enable {
    packages = [
      inputs.vein.packages.${pkgs.stdenv.hostPlatform.system}.vein
      flake.packages.${pkgs.stdenv.hostPlatform.system}.veans

      agent-browser-wrapped
      claude-wrapped
      inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode
      (unfreePkg "github-copilot-cli" inputs.nixos-unstable-small)
      pi-coding-agent-wrapped
    ];

    xdg.config.files = {
      "agents/skills".source = skills;

      "pi/agent/npm/package.json".source = ./pi/package.json;
      "pi/agent/npm/package-lock.json".source = ./pi/package-lock.json;
      "pi/agent/npm/node_modules".source = "${pi-extensions}/node_modules";
    };

    environment.sessionVariables = {
      CLAUDE_CONFIG_DIR = "${config.directory}/.config/claude";
    };
  };
}
