{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  base64,
  http,
  logs,
  ppx_sexp_conv,
  re,
  sexplib0,
  stringext,
  uri,
  uri-sexp,
  fmt,
  alcotest,
}:

buildDunePackage rec {
  pname = "cohttp";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-cohttp";
    rev = "v${version}";
    hash = "sha256-qBRwg/vqDnT/uQgpLXUkiVS4bBIB6s1dUmxXAHcGqZE=";
  };

  buildInputs = [
    ppx_sexp_conv
  ];

  propagatedBuildInputs = [
    base64
    http
    logs
    re
    sexplib0
    stringext
    uri
    uri-sexp
  ];

  checkInputs = [
    fmt
    alcotest
  ];

  meta = {
    description = "An OCaml library for HTTP clients and servers using Lwt or Async";
    homepage = "https://github.com/mirage/ocaml-cohttp";
    changelog = "https://github.com/mirage/ocaml-cohttp/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "cohttp";
    platforms = lib.platforms.all;
  };
}
