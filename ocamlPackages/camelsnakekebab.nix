{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,

  base,
  ounit,
  ocaml_pcre,
}:

buildDunePackage rec {
  pname = "camelsnakekebab";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "swuecho";
    repo = "camelsnakekebab";
    rev = version;
    hash = "sha256-moECf/7VUdEkHZMpZ43pE45w5JXD4S7R1yhvKgqDTNw=";
  };

  propagatedBuildInputs = [
    base
    ocaml_pcre
  ];

  checkInputs = [
    ounit
  ];

  doCheck = true;

  meta = {
    description = "A Ocaml library for word case conversions";
    homepage = "https://github.com/swuecho/camelsnakekebab";
    # license = lib.licenses.unfree; # No license in repo
    maintainers = with lib.maintainers; [ adamcstephens ];
    platforms = ocaml.meta.platforms;
  };
}
