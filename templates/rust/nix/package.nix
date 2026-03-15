{
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "TODO";
  version = (lib.importTOML ../Cargo.toml).package.version;

  src =
    with lib.fileset;
    toSource {
      root = ../.;
      fileset = unions [
        ../Cargo.toml
        ../Cargo.lock
        ../src
      ];
    };

  cargoLock.lockFile = ../Cargo.lock;

  meta.mainProgram = "TODO";
}
