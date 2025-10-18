{
  buildDunePackage,

  cohttp,
  http,
  logs,
  lwt,
  ppx_sexp_conv,
  sexplib0,
  uri,
}:

buildDunePackage {
  pname = "cohttp-lwt";

  inherit (cohttp) meta src version;

  buildInputs = [
    ppx_sexp_conv
  ];

  propagatedBuildInputs = [
    http
    cohttp
    lwt
    sexplib0
    logs
    uri
  ];

  checInputs = [ ];
}
