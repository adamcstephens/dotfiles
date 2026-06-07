{
  static ? true,

  lib,
  ocamlPackages,
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

  # only care about bin
  postInstall = ''
    rm -rf $out/lib

    # bash-ported tools that are no longer built by dune
    install -Dm755 bin/ssh-agent-mgr $out/bin/ssh-agent-mgr
    install -Dm755 bin/vcs-tui $out/bin/vcs-tui
  '';

  buildInputs = with ocamlPackages; [
    eio
    eio_main
    fileutils
    ppx_deriving
    ppxlib
    yojson
  ];
}
