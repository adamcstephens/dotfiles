{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
}:
buildDunePackage rec {
  pname = "cmdlang";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "mbarbin";
    repo = "cmdlang";
    tag = version;
    hash = "sha256-cfGGvW7AMvnfW5nyO08ufFSNk0PHNE6lDbhg/XqbRwY=";
  };

  postUnpack = ''
    export HOME=$PWD
  '';

  doCheck = true;

  meta = {
    description = "Declarative command-line parsing for OCaml";
    homepage = "https://github.com/mbarbin/cmdlang";
    changelog = "https://github.com/mbarbin/cmdlang/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "cmdlang";
    platforms = ocaml.meta.platforms;
  };
}
