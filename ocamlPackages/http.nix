{
  buildDunePackage,
  cohttp,

  alcotest,
  base_quickcheck,
  crowbar,
  odoc,
  ppx_assert,
  ppx_compare,
  ppx_expect,
  ppx_here,
  ppx_sexp_conv,
  sexplib0,
}:

buildDunePackage {
  pname = "http";

  inherit (cohttp) src version meta;

  checkInputs = [
    ppx_expect
    alcotest
    base_quickcheck
    ppx_assert
    ppx_sexp_conv
    ppx_compare
    ppx_here
    crowbar
    sexplib0
    odoc
  ];

  doCheck = true;
}
