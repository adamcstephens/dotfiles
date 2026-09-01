{
  config,
  inputs,
  pkgs,
  ...
}:
let
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
in
{
  packages = [
    pkgs.vikunja.veans

    claude-wrapped
  ];

  environment.sessionVariables = {
    CLAUDE_CONFIG_DIR = "${config.directory}/.config/claude";
  };
}
