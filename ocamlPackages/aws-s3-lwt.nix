{
  buildDunePackage,
  aws-s3,
  cmdliner,
  conduit-lwt,
  conduit-lwt-unix,
  ipaddr,
  ppx_inline_test,
  ppx_protocol_conv_json,
  ppx_protocol_conv_xmlm,
}:

buildDunePackage {
  pname = "aws-s3-lwt";

  inherit (aws-s3) src meta version;

  propagatedBuildInputs = [
    aws-s3
    cmdliner
    conduit-lwt
    conduit-lwt-unix
    ipaddr
    ppx_inline_test
    ppx_protocol_conv_json
    ppx_protocol_conv_xmlm
  ];

  doCheck = true;
}
