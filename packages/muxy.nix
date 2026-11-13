{
  lib,
  rustPlatform,
  fetchFromGitHub,
  callPackage,
  gitMinimal,
  pkg-config,
  wrapGAppsHook3,
  makeWrapper,
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
  python3,
  cctools,
  libicns,
}:

let
  ghosttySrc = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    # see vendor/libghostty-vt-sys/build.rs
    rev = "83fb95624b0439ee660c2679b43b38c8b63769cd";
    hash = "sha256-ywmIjwix0P5TC8kD/zTmt82CNrLXMFETaWZj0NirpoM=";
  };
  ghosttyDeps = callPackage "${ghosttySrc}/build.zig.zon.nix" { };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "muxy";
  version = "2.5.0";
  buildNumber = "1346";
  __structuredAttrs = true;

  outputs = [
    "out"
    "gui"
    "server"
  ];
  wrapGAppsInOutputs = lib.optionals stdenv.hostPlatform.isLinux [ "gui" ];

  src = fetchFromGitHub {
    owner = "muxy-app";
    repo = "muxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VIumNyaBub+89a4P842H0zmsaUS9RSLNG9yV6xcEPdc=";
  };

  cargoHash = "sha256-RVZuabBbgX/MEZeBwF3Gzr/A33TG/+j9Y2A8qrpwzFw=";

  dontUseZigConfigure = true;
  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    makeWrapper
    gitMinimal
    zig_0_17
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    python3
    cctools.libtool
    cctools
    libicns
  ];

  nativeCheckInputs = [ openssh ];

  buildFeatures = lib.optionals stdenv.hostPlatform.isDarwin [ "gpui/runtime_shaders" ];

  checkFlags = [
    "--skip=dialog::picker::tests::the_dialog_starts_in_the_nearest_existing_folder_with_its_exact_bytes"
  ];

  postPatch = ''
    substituteInPlace crates/muxy-server/tests/history_links.rs \
      --replace-fail /bin/sleep ${lib.getExe' coreutils "sleep"}
    substituteInPlace crates/muxy-cli/src/open.rs \
      --replace-fail ${lib.escapeShellArg "    let Ok(executable) = muxy_core::executable::current_path() else {\n        return false;\n    };\n    desktop_session"} '    desktop_session' \
      --replace-fail 'launch(&executable.with_file_name("muxy-app"), folder)' 'launch(Path::new("muxy-app"), folder)'
  '';

  buildInputs = [
    libgit2
    sqlite
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    atk
    cairo
    fontconfig
    freetype
    gdk-pixbuf
    glib
    glib-networking
    gtk3
    libsoup_3
    libxkbcommon
    pango
    vulkan-loader
    webkitgtk_4_1
    wayland
    libx11
    libxcb
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    GHOSTTY_SOURCE_DIR = ghosttySrc;
    GHOSTTY_ZIG_SYSTEM_DIR = ghosttyDeps;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    MACOSX_DEPLOYMENT_TARGET = "14.0";
  };

  preCheck = ''
    export HOME=$(mktemp --directory)
  '';

  postInstall = ''
    mkdir --parents "$gui/bin" "$server/bin"
    mv "$out/bin/muxy-app" "$gui/bin/"
    mv "$out/bin/muxy-server" "$server/bin/"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    app="$gui/Applications/Muxy.app"
    mkdir --parents "$app/Contents/MacOS" "$app/Contents/Resources"
    mv "$gui/bin/muxy-app" "$app/Contents/MacOS/"
    ln --symbolic "$out/bin/muxy" "$app/Contents/MacOS/muxy"
    ln --symbolic "$server/bin/muxy-server" "$app/Contents/MacOS/muxy-server"
    png2icns "$app/Contents/Resources/AppIcon.icns" packaging/macos/AppIcon.png
    python3 scripts/release.py plist ${finalAttrs.version} "$app/Contents/Info.plist" \
      --build ${finalAttrs.buildNumber}
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --set-default MUXY_SERVER_BIN "$server/bin/muxy-server"
      --suffix PATH : "$out/bin"
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    )
  '';

  postFixup = ''
    wrapProgram "$out/bin/muxy" \
      --set-default MUXY_SERVER_BIN "$server/bin/muxy-server"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper "$gui/Applications/Muxy.app/Contents/MacOS/muxy-app" "$gui/bin/muxy-app" \
      --set-default MUXY_SERVER_BIN "$gui/Applications/Muxy.app/Contents/MacOS/muxy-server" \
      --suffix PATH : "$out/bin"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight and Memory efficient terminal multiplexer";
    homepage = "https://github.com/muxy-app/muxy";
    changelog = "https://github.com/muxy-app/muxy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "muxy";
    outputsToInstall = [ "out" ];
  };
})
