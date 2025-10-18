{
  buildDunePackage,
  oooapi,

  camelsnakekebab,
  cohttp-lwt-unix,
  http,
  multipart_form,
  multipart_form-cohttp-lwt,
  multipart_form-lwt,
  openapi_spec,
  ppx_deriving,
  ppx_deriving_yojson,
  ppx_expect,
  tezt,
  tls,
  tls-lwt,
  uuidm,
}:

buildDunePackage {
  pname = "oooapi_lib";

  inherit (oooapi) meta src version;
  buildInputs = [
    ppx_deriving_yojson
    ppx_deriving
  ];

  propagatedBuildInputs = [
    openapi_spec
    multipart_form
    multipart_form-lwt
    multipart_form-cohttp-lwt
    uuidm
    cohttp-lwt-unix
    http
    tls
    tls-lwt
    camelsnakekebab
  ];

  checInputs = [
    ppx_expect
    tezt
  ];
}
