{
  cmdliner,
  buildDunePackage,
  cmdlang,
}:

buildDunePackage {
  pname = "cmdlang-to-cmdliner";
  version = "0.0.9";

  inherit (cmdlang) src meta;

  postUnpack = ''
    export HOME=$PWD
  '';

  propagatedBuildInputs = [
    cmdlang
    cmdliner
  ];

  doCheck = true;
}
