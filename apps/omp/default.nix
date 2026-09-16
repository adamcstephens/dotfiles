{
  config,
  inputs,
  pkgs,
  ...
}:
let
  omp-wrapped = pkgs.symlinkJoin {
    name = "omp-wrapped";
    paths = [
      inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.omp
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/omp \
        --set-default PI_CONFIG_DIR ".config/omp"
    '';
  };
in
{
  packages = [
    omp-wrapped
  ];

  xdg.config.files = {
    "omp/agent/AGENTS.md".source = config.xdg.config.files."agents/AGENTS.md".source;
    "omp/agent/config.yml".source = "${config.directory}/.dotfiles/apps/omp/config.yml";
    "omp/agent/extensions".source = "${config.directory}/.dotfiles/apps/omp/extensions";
    "omp/agent/skills".source = config.xdg.config.files."agents/skills".source;
  };
}
