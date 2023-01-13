{
  fetchFromGitHub,
  stdenv,
  xorg,
}:
stdenv.mkDerivation rec {
  name = "xautocfg";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "SFTtech";
    repo = name;
    rev = "refs/tags/v${version}";
    hash = "sha256-MzSH2jBJEdAbXASxIupeUbuiIb+U+jDbeBTMFlxDEc8=";
  };

  strictDeps = true;
  buildInputs = [
    xorg.libX11
    xorg.libXi
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp xautocfg $out/bin
  '';
}
