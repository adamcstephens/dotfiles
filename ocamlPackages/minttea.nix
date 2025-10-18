{
  lib,
  ocamlPackages,
  fetchFromGitHub,
  fetchpatch,
}:
let
  ocamlPackages' = ocamlPackages.overrideScope (
    self: super: {
      gluon = super.gluon.overrideAttrs (_: {
        patches = [
          # remove when >= 0.0.10 released
          (fetchpatch {
            url = "https://github.com/riot-ml/gluon/commit/b29c34d04ea05d7721a229c35132320e796ed4b2.patch";
            hash = "sha256-XuzyoteQAgEs93WrgHTWT1I+hIJAiGiJ4XAiLtnEYtw=";
          })
        ];

      });
      riot = super.riot.overrideAttrs (old: {
        version = "0.0.9-dev";
        src = fetchFromGitHub {
          owner = "riot-ml";
          repo = "riot";
          rev = "310a4868edaa4f97304ca5398f23d843b8b26eae";
          hash = "sha256-K+VUI7XIVB80rWAjc1uhN5/MNtlAol67Sq5Z62HdeWo=";
        };
        patches = [ ];
        meta.broken = false;
      });

    }
  );
in
ocamlPackages'.buildDunePackage rec {
  pname = "minttea";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "leostera";
    repo = "minttea";
    rev = "aa5ef898f6ce4b2a5b359dd6f985cbe2a3583b70";
    hash = "sha256-UJSaLEh76d4p7FL33+zSnyNfcCqdP3sgvCQdMFSEC2o=";
  };

  propagatedBuildInputs = with ocamlPackages'; [
    riot
    mdx
    tty
    uuseg
    odoc
  ];
  dontDetectOcamlConflicts = true;

  meta = {
    description = "A fun little TUI framework for OCaml";
    homepage = "https://github.com/leostera/minttea";
    changelog = "https://github.com/leostera/minttea/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "minttea";
    platforms = lib.platforms.all;
  };
}
