{
  config,
  dotlib,
  inputs,
  pkgs,
  ...
}:
let
  claude-wrapped = pkgs.symlinkJoin {
    name = "claude-wrapped";
    paths = [ (dotlib.unfreePkg "claude-code" inputs.nixos-unstable-small) ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --set-default CLAUDE_CONFIG_DIR "${config.xdg.configHome}/claude" \
        --set-default NODE_EXTRA_CA_CERTS "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    '';
  };
in
{
  home.packages = [
    claude-wrapped
  ];

  home.sessionVariables = {
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
  };

  smfh.xdg.config.files."claude/CLAUDE.md".source =
    config.smfh.xdg.config.files."agents/AGENTS.md".source;
}
