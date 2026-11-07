{
  lib,
  rustPlatform,
  fetchFromGitHub,
  callPackage,
  gitMinimal,
  pkg-config,
  wrapGAppsHook3,
  atk,
  cairo,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libgit2,
  libsoup_3,
  libxkbcommon,
  pango,
  sqlite,
  vulkan-loader,
  webkitgtk_4_1,
  zlib,
  stdenv,
  wayland,
  libx11,
  libxcb,
  zig_0_17,
  nix-update-script,
  openssh,
  coreutils,
}:

let
  ghosttySrc = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    rev = "83fb95624b0439ee660c2679b43b38c8b63769cd";
    hash = "sha256-ywmIjwix0P5TC8kD/zTmt82CNrLXMFETaWZj0NirpoM=";
  };
  ghosttyDeps = callPackage "${ghosttySrc}/build.zig.zon.nix" { };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "muxy";
  version = "2.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "muxy-app";
    repo = "muxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zwd2X18Kr22rYH9r8OQvofHWCwvomTn+4tBYMmFAuos=";
  };

  cargoHash = "sha256-nj1Nf0yHC9AcpvdydO3pZfhKnhQtaFB4geTxnjf5Bu0=";

  dontUseZigConfigure = true;
  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook3
    gitMinimal
    zig_0_17
  ];

  nativeCheckInputs = [ openssh ];

  postPatch = ''
    substituteInPlace crates/muxy-server/tests/history_links.rs \
      --replace-fail /bin/sleep ${lib.getExe' coreutils "sleep"}
  '';

  buildInputs = [
    atk
    cairo
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libgit2
    libsoup_3
    libxkbcommon
    pango
    sqlite
    vulkan-loader
    webkitgtk_4_1
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libx11
    libxcb
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    GHOSTTY_SOURCE_DIR = ghosttySrc;
    GHOSTTY_ZIG_SYSTEM_DIR = ghosttyDeps;
  };

  preCheck = ''
    export HOME=$(mktemp --directory)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight and Memory efficient terminal multiplexer";
    homepage = "https://github.com/muxy-app/muxy";
    changelog = "https://github.com/muxy-app/muxy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "muxy";
  };
})
