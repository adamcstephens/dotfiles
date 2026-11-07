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
  glib-networking,
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

  outputs = [
    "out"
    "gui"
    "server"
  ];
  wrapGAppsInOutputs = [ "gui" ];

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
    substituteInPlace crates/muxy-cli/src/open.rs \
      --replace-fail ${lib.escapeShellArg "    let Ok(executable) = muxy_core::executable::current_path() else {\n        return false;\n    };\n    desktop_session"} '    desktop_session' \
      --replace-fail 'launch(&executable.with_file_name("muxy-app"), folder)' 'launch(Path::new("muxy-app"), folder)'
  '';

  buildInputs = [
    atk
    cairo
    fontconfig
    freetype
    gdk-pixbuf
    glib
    glib-networking
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

  postInstall = ''
    mkdir --parents "$gui/bin" "$server/bin"
    mv "$out/bin/muxy-app" "$gui/bin/"
    mv "$out/bin/muxy-server" "$server/bin/"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default MUXY_SERVER_BIN "$server/bin/muxy-server"
      --suffix PATH : "$out/bin"
    )
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}")
  '';

  postFixup = ''
    wrapProgram "$out/bin/muxy" \
      --set-default MUXY_SERVER_BIN "$server/bin/muxy-server"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight and Memory efficient terminal multiplexer";
    homepage = "https://github.com/muxy-app/muxy";
    changelog = "https://github.com/muxy-app/muxy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "muxy";
    outputsToInstall = [ "out" ];
  };
})
