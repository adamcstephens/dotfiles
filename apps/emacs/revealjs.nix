{ fetchFromGitHub, stdenv }:
stdenv.mkDerivation rec {
  name = "revealjs";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "hakimel";
    repo = "reveal.js";
    rev = "refs/tags/${version}";
    hash = "sha256-bqNgaBT6WPfumhdG1VPZ6ngn0QA9RDuVtVJtVwxbOd4=";
  };

  dontBuild = true;
  dontPatch = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    mkdir -vp $out
    cp -r * $out
  '';
}
