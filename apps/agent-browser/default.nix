{
  inputs,
  lib,
  pkgs,
  ...
}:
let
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
  packages = [
    agent-browser-wrapped
  ];
}
