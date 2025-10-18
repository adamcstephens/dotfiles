{
  buildDunePackage,
  alcotest,
  ppx_expect,
  ppx_protocol_conv,
  sexplib,
  yojson,
}:

buildDunePackage {
  pname = "ppx_protocol_conv_json";

  inherit (ppx_protocol_conv) src meta version;

  propagatedBuildInputs = [
    ppx_expect
    ppx_protocol_conv
    sexplib
    yojson
  ];

  doCheck = true;

  checkInputs = [
    alcotest
  ];
}
