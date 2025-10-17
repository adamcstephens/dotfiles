{
  lib,
  fetchFromGitHub,
  gcc12Stdenv,
  xorg,
}:
# needs higher gcc for aarch64 until https://github.com/NixOS/nixpkgs/issues/108305
gcc12Stdenv.mkDerivation rec {
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

  meta = with lib; {
    description = "Automatic keyboard repeat rate configuration for new keyboards";
    homepage = "https://github.com/SFTtech/xautocfg";
    license = licenses.gpl3;
    maintainers = with maintainers; [ adamcstephens ];
  };
}
