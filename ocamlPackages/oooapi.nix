{
  lib,
  buildDunePackage,
  fetchFromGitHub,

  camelsnakekebab,
  cohttp-lwt-unix,
  http,
  multipart_form,
  multipart_form-cohttp-lwt,
  multipart_form-lwt,
  oooapi_lib,
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
  pname = "oooapi";
  version = "unstable-2024-02-19";

  src = fetchFromGitHub {
    owner = "XFFS";
    repo = "OooapI";
    rev = "432ec8150fcbc21725cc2b18728f5e92e583134c";
    hash = "sha256-XDaCUCdlLhCTu6rMdHRIvXknXr1Xz4HrFemjpyF2aS4=";
  };

  buildInputs = [
    ppx_deriving
    ppx_deriving_yojson
  ];

  propagatedBuildInputs = [
    camelsnakekebab
    cohttp-lwt-unix
    http
    multipart_form
    multipart_form-cohttp-lwt
    multipart_form-lwt
    oooapi_lib
    openapi_spec
    tls
    tls-lwt
    uuidm
  ];

  checkInputs = [
    ppx_expect
    tezt
  ];

  # tests fail on sandbox dune cache error, so let them cache
  preCheck = ''
    export HOME=$PWD
  '';

  doCheck = true;

  meta = {
    description = "OCaml of OpenAPI";
    homepage = "https://github.com/XFFS/OooapI";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamcstephens ];
    platforms = lib.platforms.all;
  };
}
