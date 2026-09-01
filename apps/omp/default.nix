{
  inputs,
  pkgs,
  ...
}:
let
  omp-wrapped = pkgs.symlinkJoin {
    name = "omp-wrapped";
    paths = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.omp
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
}
