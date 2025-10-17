{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  protobuf,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "vim-zellij-navigator";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hiasr";
    repo = "vim-zellij-navigator";
    rev = version;
    hash = "sha256-1zzY1Z8ZpiNTdFW+gKRYaRR+oCzMnbJA2szY0k24bGg=";
  };

  cargoHash = "sha256-AbfgDhQEbm5qULw2HHxG5EMCYdML4VhHxJaAqP2g3u0=";

  nativeBuildInputs = [
    # curl
    pkg-config
    protobuf
  ];

  buildInputs = [
    # curl
    # openssl
    # zlib
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    description = "";
    homepage = "https://github.com/hiasr/vim-zellij-navigator";
    license = [ ]; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ ];
    mainProgram = "vim-zellij-navigator";
  };
}
