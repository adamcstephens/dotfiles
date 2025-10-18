{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  alcotest,
  angstrom,
  base64,
  bigstringaf,
  fmt,
  ke,
  logs,
  pecu,
  prettym,
  rosetta,
  rresult,
  unstrctrd,
  uutf,
}:

buildDunePackage rec {
  pname = "multipart_form";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dinosaure";
    repo = "multipart_form";
    rev = "v${version}";
    hash = "sha256-aW8TOnzzJmuqN4ddUgoLbX8FefBC3nkPXiLn11C7QCs=";
  };

  propagatedBuildInputs = [
    angstrom
    base64
    unstrctrd
    uutf
    pecu
    prettym
    fmt
    logs
    ke
    bigstringaf
  ];

  checkInputs = [
    alcotest
    rosetta
    rresult
  ];

  meta = {
    description = "According an other RFC2388";
    homepage = "https://github.com/dinosaure/multipart_form";
    changelog = "https://github.com/dinosaure/multipart_form/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "multipart-form";
    platforms = lib.platforms.all;
  };
}
