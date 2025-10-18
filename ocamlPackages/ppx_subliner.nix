{
  lib,
  buildDunePackage,
  fetchFromGitHub,

  alcotest,
  bisect_ppx,
  cmdliner,
  ppx_deriving_cmdliner,
  ppx_make,
  ppx_show,
  ppxlib,
}:

buildDunePackage rec {
  pname = "ppx_subliner";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "bn-d";
    repo = "ppx_subliner";
    rev = "v${version}";
    hash = "sha256-uqOYn4hdkbfiP2hEg/WA+CxwRtqaV2G5rE8P9gh/4ts=";
  };

  buildInputs = [
    bisect_ppx
    ppx_deriving_cmdliner
    ppxlib
    ppx_make
    ppx_show
  ];

  propagatedBuildInputs = [
    cmdliner
  ];

  checkInputs = [
    alcotest
  ];

  meta = {
    description = "Deriving] plugin to generate Cmdliner sub-command groups, and ppx rewriter to generate Cmdliner evaluations";
    homepage = "https://github.com/bn-d/ppx_subliner";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ppx-subliner";
  };
}
