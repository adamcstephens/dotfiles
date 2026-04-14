{
  lib,
  stdenv,
  fetchFromGitHub,
  swift,
  xcbuildHook,
  darwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dark-mode";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "dark-mode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vgk26fXrtICYyjxsAomVsgr+iEf3ca3U+KRyXF0HxTM=";
  };

  postPatch = ''
    #test
    substituteInPlace dark-mode.xcodeproj/project.pbxproj \
      --replace-fail 'MACOSX_DEPLOYMENT_TARGET = 10.10' \
                     'MACOSX_DEPLOYMENT_TARGET = ${stdenv.hostPlatform.darwinMinVersion}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    swift
    xcbuildHook
  ];

  installPhase = ''
    runHook preInstall
    install -D -m755 -t "$out/bin" Products/Release/dark-mode
    runHook postInstall
  '';

  postInstall = ''
    cat > entitlements.plist << 'EOF'
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>com.apple.security.automation.apple-events</key>
      <true/>
    </dict>
    </plist>
    EOF
    ${darwin.sigtool}/bin/codesign \
      --force --sign - \
      --entitlements entitlements.plist \
      "$out/bin/dark-mode"
  '';

  env.NIX_CFLAGS_LINK = "-L/usr/lib/swift -lswiftCore";

  __structuredAttrs = true;

  meta = {
    description = "Control the macOS dark mode from the command-line";
    homepage = "https://github.com/sindresorhus/dark-mode";
    license = lib.licenses.mit;
    mainProgram = "dark-mode";
    platforms = lib.platforms.darwin;
  };
})
