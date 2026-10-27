{
  config,
  dotlib,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  chromium =
    if pkgs.stdenv.hostPlatform.isLinux then
      lib.getExe pkgs.chromium
    else
      "/Applications/Chromium.app/Contents/MacOS/Chromium";

  omp-wrapped = pkgs.symlinkJoin {
    name = "omp-wrapped";
    paths = [
      inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.omp
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/omp \
        --set-default PI_CONFIG_DIR ".config/omp"\
        --set PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true \
        --set PUPPETEER_EXECUTABLE_PATH "${chromium}"
    '';
  };
in
{
  home.packages = [
    omp-wrapped
  ];

  xdg.configFile = {
    "omp/agent/AGENTS.md".source = config.xdg.configFile."agents/AGENTS.md".source;
    "omp/agent/SYSTEM_TEMPLATE.md".source = dotlib.source "apps/omp/SYSTEM_TEMPLATE.md";
    "omp/agent/config.yml".source = dotlib.source "apps/omp/config.yml";
    "omp/agent/extensions".source = dotlib.source "apps/omp/extensions";
    "omp/agent/lsp.json".source = dotlib.source "apps/omp/lsp.json";
    "omp/agent/skills".source = config.xdg.configFile."agents/skills".source;
    "omp/agent/themes".source = dotlib.source "apps/omp/themes";
  };
}
