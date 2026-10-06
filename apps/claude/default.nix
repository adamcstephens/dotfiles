{
  config,
  inputs,
  pkgs,
  ...
}:
let
  claude-wrapped = pkgs.symlinkJoin {
    name = "claude-wrapped";
    paths = [ (config.dotfiles.unfreePkg "claude-code" inputs.nixos-unstable-small) ];
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
