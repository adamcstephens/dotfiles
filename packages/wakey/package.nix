{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "wakey";
  version = "unstable-2025-06-30";

  src = fetchFromGitHub {
    owner = "LesnyRumcajs";
    repo = "wakey";
    rev = "c6ed8ba411b73df2652d7894a1eff9ffbbc5c7c3";
    hash = "sha256-CA+mCdcRmowFrvlwaSiLTIlDX3NwQ/Wvf01raLr98iQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  checkFlags = [
    # isn't panic'ing?
    "--skip=tests::extend_mac_mac_too_short_test"
  ];

  meta = {
    description = "Rust Wake-on-LAN library";
    homepage = "https://github.com/LesnyRumcajs/wakey";
    changelog = "https://github.com/LesnyRumcajs/wakey/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "wakey-wake";
  };
}
