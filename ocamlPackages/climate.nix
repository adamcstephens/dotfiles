{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
}:

buildDunePackage rec {
  pname = "climate";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "gridbugs";
    repo = "climate";
    tag = version;
    hash = "sha256-geafeU3WL+pXVDIKncN4xR4dVnVBxTBeSLD/jew0wm8=";
  };

  postUnpack = ''
    export HOME=$PWD
  '';

  doCheck = true;

  meta = {
    description = " A declarative command-line parser for OCaml ";
    homepage = "https://github.com/gridbugs/climate";
    changelog = "https://github.com/gridbugs/climate/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "cmdlang";
    platforms = ocaml.meta.platforms;
  };
}
