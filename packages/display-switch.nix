{
  apple-sdk_15,
  darwin,
  fetchFromGitHub,
  lib,
  libgit2,
  libusb1,
  pkg-config,
  rustPlatform,
  stdenv,
  udev,
  versionCheckHook,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "display-switch";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "haimgel";
    repo = "display-switch";
    tag = finalAttrs.version;
    hash = "sha256-pUZNIEpzFZN5fc6TBedhL+7LJdw2R10w3BqzvLt+RYk=";
  };

  cargoHash = "sha256-AF6A880V4rZSxpfdnYNbXSi0Mz1Ig+ZOFMtI6pxKqeA=";

  env = {
    VERGEN_GIT_COMMIT_TIMESTAMP = "0";
    VERGEN_GIT_BRANCH = "main";
    VERGEN_GIT_DESCRIBE = finalAttrs.version;
    VERGEN_GIT_SHA = finalAttrs.src.tag;
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];

  buildInputs = [
    libgit2
    libusb1
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  checkFlags = [
    # TODO
    "--skip=configuration::tests::test_log_file_name"
    # actually tries to wake displays
    "--skip=platform::wake_displays::tests::test_wake_displays"
  ];

  postInstall = ''
    mv $out/bin/display_switch $out/bin/display-switch
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Turn a $30 USB switch into a full-featured multi-monitor KVM switch";
    homepage = "https://github.com/haimgel/display-switch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "display-switch";
  };
})
