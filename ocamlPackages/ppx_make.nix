{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppxlib,
  ounit2,
  ppx_show,
  bisect_ppx,
}:

buildDunePackage rec {
  pname = "ppx_make";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "bn-d";
    repo = "ppx_make";
    rev = "v${version}";
    hash = "sha256-jR+2l5JcB3wT0YsnQCTwptarp4cZwi8GFweQEwSn4oo=";
  };

  buildInputs = [
    ppxlib
  ];
  checkInputs = [
    ounit2
    ppx_show
    bisect_ppx
  ];

  meta = {
    description = "Deriving] plugin to generate make functions";
    homepage = "https://github.com/bn-d/ppx_make";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ppx-make";
  };
}
