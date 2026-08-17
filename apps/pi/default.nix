{
  config,
  inputs,
  pkgs,
  ...
}:
let
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
  packages = [
    pi-coding-agent-wrapped
  ];

  xdg.config.files = {
    "pi/agent/npm/package.json".source = ./pi/package.json;
    "pi/agent/npm/package-lock.json".source = ./pi/package-lock.json;
    "pi/agent/npm/node_modules".source = "${pi-extensions}/node_modules";
  };
}
