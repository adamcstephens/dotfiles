{
  static ? false,

  lib,
  ocamlPackages,
  stdenv,
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
      fileset = unions (
        [
          ../bin/dune
          ../bin/escape_file.ml
          ../lib
          ../dune-project
        ]
        ++ lib.optionals stdenv.isLinux [
          ../bin/wayland_locker.ml
        ]
      );
    };

  buildInputs = with ocamlPackages; [
    eio
    eio_main
    fileutils
    ppx_deriving
    ppxlib
    yojson
  ];
}
