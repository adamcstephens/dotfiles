{
  lib,
  stdenv,
  fetchFromGitHub,
  darwin,
}:
stdenv.mkDerivation rec {
  pname = "m1ddc";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "waydabber";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-obs2qQvSkIDsWhCXJOF1Geiqqy19KDf0InyxRVod4hk=";
  };

  postPatch = ''
    # patch out constant which requires sdk 12, this should choose the default still
    substituteInPlace sources/ioregistry.m --replace-fail 'kIOMainPortDefault' 'MACH_PORT_NULL'
  '';

  nativeBuildInputs = with darwin.apple_sdk_11_0.frameworks; [
    CoreDisplay
    Foundation
    IOKit
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp m1ddc $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/waydabber/m1ddc";
    description = "Controls external displays (connected via USB-C/DisplayPort Alt Mode) using DDC/CI on M1 Macs";
    license = licenses.mit;
    maintainers = with maintainers; [ adamcstephens ];
    platforms = platforms.darwin;
  };
}
