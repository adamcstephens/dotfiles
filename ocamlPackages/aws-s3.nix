{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  base64,
  digestif,
  inifiles,
  ppx_inline_test,
  ppx_protocol_conv_json,
  ppx_protocol_conv_xmlm,
  ptime,
  uri,
  yojson,
}:

buildDunePackage rec {
  pname = "aws-s3";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "andersfugmann";
    repo = "aws-s3";
    rev = version;
    hash = "sha256-Hi3WUW7nmMc4YwJlMkDKY3FGts/JLPaovfe4i5GGq38=";
  };

  propagatedBuildInputs = [
    base64
    digestif
    inifiles
    ppx_inline_test
    ppx_protocol_conv_json
    ppx_protocol_conv_xmlm
    ptime
    uri
    yojson
  ];

  meta = {
    description = "Ocaml library to access Amazon S3";
    homepage = "https://github.com/andersfugmann/aws-s3";
    changelog = "https://github.com/andersfugmann/aws-s3/blob/${src.rev}/Changelog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "aws-s3";
  };
}
