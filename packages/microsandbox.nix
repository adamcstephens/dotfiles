{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  dbus,
  sqlite,
  zstd,
  nix-update-script,
  pkgsStatic,
  stdenv,
  linuxPackages_6_12,
  flex,
  bison,
  bc,
  cpio,
  perl,
  python3,
  elfutils,
  libkrunfw,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microsandbox";
  version = "0.7.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "superradcompany";
    repo = "microsandbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IS55FpCT0r0KPmjczyzsUGwkoKvGQIRUs4xxaYxYxWk=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-SCQnx6ibf//lEdWcmD0ACrhl4GvzKf9hYGQyPPfUVS4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    dbus
    sqlite
    zstd
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    MSB_EMBED_ARTIFACTS_DIR = "${finalAttrs.agentd}/bin";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  agentd = pkgsStatic.rustPlatform.buildRustPackage {
    pname = "microsandbox-agentd";
    inherit (finalAttrs) version src cargoHash;

    cargoBuildFlags = [
      "--package"
      "microsandbox-agentd"
    ];

    cargoTestFlags = [
      "--package"
      "microsandbox-agentd"
    ];

    doCheck = false;
  };

  libkrunfw = stdenv.mkDerivation (firmwareAttrs: {
    pname = "microsandbox-libkrunfw";
    version = "5.6.1";
    src = "${finalAttrs.src}/vendor/libkrunfw";
    __structuredAttrs = true;

    kernelSrc = linuxPackages_6_12.kernel.src;

    postPatch = ''
      patchShebangs scripts
      substituteInPlace Makefile \
        --replace-fail 'curl --fail --location --retry 5 --retry-delay 2 $(KERNEL_REMOTE) -o $(KERNEL_TARBALL)' \
        'ln --symbolic ${firmwareAttrs.kernelSrc} $(KERNEL_TARBALL)'
    '';

    nativeBuildInputs = [
      flex
      bison
      bc
      cpio
      perl
      python3
      python3.pkgs.pyelftools
    ];

    buildInputs = [
      elfutils
    ];

    makeFlags = [
      "PREFIX=${placeholder "out"}"
      "LIBDIR_Linux=lib"
      "KERNEL_VERSION=linux-${linuxPackages_6_12.kernel.version}"
    ];

    env = lib.optionalAttrs stdenv.hostPlatform.isAarch64 {
      NIX_CFLAGS_COMPILE = "-march=armv8-a+crypto";
    };

    enableParallelBuilding = true;

    inherit (libkrunfw) meta;
  });

  postInstall = ''
    mkdir --parents "$out/lib"
    ln --symbolic ${finalAttrs.libkrunfw}/lib/libkrunfw.so.${finalAttrs.libkrunfw.version} "$out/lib/"
  '';

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "embed-binaries"
    "net"
    "keyring"
    "ssh"
  ];

  cargoBuildFlags = [
    "--package"
    "microsandbox-cli"
  ];

  cargoTestFlags = [
    "--package"
    "microsandbox-cli"
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy, fast, programmable and local-first microVM runtime and library";
    homepage = "https://github.com/superradcompany/microsandbox";
    changelog = "https://github.com/superradcompany/microsandbox/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "msb";
  };
})
