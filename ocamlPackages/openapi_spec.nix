{
  buildDunePackage,
  oooapi,

  atdgen,
  ppx_expect,
  tezt,
  uri,
  yojson,
}:

buildDunePackage {
  pname = "openapi_spec";

  inherit (oooapi) meta src version;

  propagatedBuildInputs = [
    atdgen
    uri
    yojson
  ];

  checInputs = [
    ppx_expect
    tezt
  ];
}
