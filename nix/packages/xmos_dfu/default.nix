{
  stdenv,
  fetchFromGitHub,
  libusb1,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "xmos_dfu";
  version = "20220511";

  src = fetchFromGitHub {
    owner = "jdslabs";
    repo = "xmos_dfu";
    rev = "b60e7b68364fe9675c43792460537cfad4f0df1b";
    hash = "sha256-ooPF4TQ9usDVy+p1d2JtFlGeOqa49YaiqUUkLoptcoo=";
  };

  dontConfigure = true;
  dontFixup = true;
  dontPatch = true;

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libusb1
  ];

  buildPhase = ''
    cd xmos_dfu
    make linux
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp xmosdfu $out/bin
  '';

  meta.mainProgram = "xmosdfu";
}
