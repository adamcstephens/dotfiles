{
  buildDunePackage,

  alcotest,
  alcotest-lwt,
  angstrom,
  bigstringaf,
  fmt,
  ke,
  logs,
  lwt,
  multipart_form,
  rosetta,
  rresult,
  unstrctrd,
}:

buildDunePackage {
  pname = "multipart_form-lwt";

  inherit (multipart_form) meta src version;

  propagatedBuildInputs = [
    angstrom
    bigstringaf
    ke
    lwt
    multipart_form
  ];

  checkInputs = [
    alcotest-lwt
    alcotest
    fmt
    rosetta
    rresult
    unstrctrd
    logs
  ];
}
