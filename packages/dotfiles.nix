{
  lib,
  ocamlPackages,
  python3,
}:

ocamlPackages.buildDunePackage {
  pname = "dotfiles";
  version = "0.1.0";

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

    # python-ported tools that are no longer built by dune
    install -Dm755 bin/dark $out/bin/dark
  '';

  # patchShebangs rewrites bin/dark's `#!/usr/bin/env python3` to this
  nativeBuildInputs = [ python3 ];

  buildInputs = with ocamlPackages; [
    eio
    eio_main
    fileutils
    ppx_deriving
    ppxlib
    yojson
  ];
}
