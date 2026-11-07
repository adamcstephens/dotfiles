{
  lib,
  rustPlatform,
  fetchFromGitHub,
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
  webkitgtk,
  zlib,
  stdenv,
  wayland,
  xorg,
  nix-update-script,
}:

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

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook3
  ];

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
    webkitgtk
    zlib
  ]
  ++ lib.optionals stdenv.isLinux [
    wayland
    xorg.libX11
    xorg.libxcb
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
  };

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
