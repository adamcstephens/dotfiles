{
  buildDunePackage,
  lib,
  fetchFromGitHub,
}:

buildDunePackage {
  pname = "stdcompat";
  version = "20-dev";

  src = fetchFromGitHub {
    owner = "thierry-martinez";
    repo = "stdcompat";
    rev = "d53390d788027fe0a2282c4745eb3d1626341f99";
    hash = "sha256-94DM61C7r8zZ3AUfZd2aTvaxMiAVC585F2A9hSF4YPY=";
  };

  # Otherwise ./configure script will run and create files conflicting with dune.
  dontConfigure = true;

  meta = {
    homepage = "https://github.com/thierry-martinez/stdcompat";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
