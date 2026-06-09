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
    paths = [ (unfreePkg "claude-code" inputs.nixpkgs-unstable-small) ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --set-default CLAUDE_CONFIG_DIR "${config.home.homeDirectory}/.config/claude"
    '';
  };

  agent-browser =
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.agent-browser;

  agent-browser-wrapped =
    if pkgs.stdenv.isLinux then
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
  options = {
    dotfiles.apps.agents.enable = lib.mkEnableOption "agent things";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.vein.packages.${pkgs.stdenv.hostPlatform.system}.vein

      agent-browser-wrapped
      claude-wrapped
      inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode
      (unfreePkg "github-copilot-cli" inputs.nixpkgs-unstable-small)
    ];

    home.file.".config/agents/skills".source = skills;

    home.sessionVariables = {
      CLAUDE_CONFIG_DIR = "${config.home.homeDirectory}/.config/claude";
    };
  };
}
