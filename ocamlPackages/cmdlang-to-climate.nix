{
  buildDunePackage,
  cmdlang,
  climate,
}:

buildDunePackage {
  pname = "cmdlang-to-climate";
  version = "0.0.9";

  inherit (cmdlang) src meta;

  postUnpack = ''
    export HOME=$PWD
  '';

  propagatedBuildInputs = [
    cmdlang
    climate
  ];

  doCheck = true;
}
