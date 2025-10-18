{
  buildDunePackage,
  alcotest,
  ezxmlm,
  ppx_protocol_conv,
  ppx_sexp_conv,
  ppxlib,
  sexplib,
}:

buildDunePackage {
  pname = "ppx_protocol_conv_xmlm";

  inherit (ppx_protocol_conv) src meta version;

  propagatedBuildInputs = [
    ezxmlm
    ppx_protocol_conv
    ppx_sexp_conv
    ppxlib
    sexplib
  ];

  doCheck = true;

  checkInputs = [
    alcotest
  ];
}
