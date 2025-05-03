{
  lib,
  ocamlPackages,
  static ? false,
}:

ocamlPackages.buildDunePackage {
  pname = "dotfiles";
  version = "0.1.0";

  env = lib.optionalAttrs static {
    BUILD_STATIC = "1";
  };

  src =
    with lib.fileset;
    toSource {
      root = ../.;
      fileset = unions [
        ../bin
        ../lib
        ../dune-project
      ];
    };

  buildInputs = with ocamlPackages; [
    eio
    eio_main
    fileutils
    yojson
  ];
}
