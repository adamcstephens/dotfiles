{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppxlib,
}:

buildDunePackage rec {
  pname = "ppx_protocol_conv";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "andersfugmann";
    repo = "ppx_protocol_conv";
    rev = version;
    hash = "sha256-pSQYY3+YpUi4j2fyY0eteaAVE2I2EyqlvE7fgzL2HIw=";
  };

  propagatedBuildInputs = [
    ppxlib
  ];

  meta = {
    description = "Pluggable serialization and deserialization of ocaml data strucures based on type_conv";
    homepage = "https://github.com/andersfugmann/ppx_protocol_conv";
    changelog = "https://github.com/andersfugmann/ppx_protocol_conv/blob/${src.rev}/Changelog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ppx-protocol-conv";
  };
}
