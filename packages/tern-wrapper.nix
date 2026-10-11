{
  buildFHSEnv,
  lib,
  makeDesktopItem,
  writeScript,
}:

let
  desktopItem = makeDesktopItem {
    name = "tern";
    desktopName = "Tern";
    genericName = "Terminal Emulator";
    comment = "Multiplexing terminal";
    exec = "tern";
    icon = "utilities-terminal";
    terminal = false;
    categories = [
      "System"
      "TerminalEmulator"
    ];
  };
in
buildFHSEnv {
  name = "tern";

  targetPkgs =
    pkgs: with pkgs; [
      libglvnd
      libpulseaudio
      libxcb
      libxkbcommon
      pam
      vulkan-loader
      wayland
    ];

  dieWithParent = false;

  runScript = writeScript "tern" ''
    #!/usr/bin/env sh
    export PI_CONFIG_DIR=".config/omp"
    exec "''${XDG_DATA_HOME:-$HOME/.local/share}/tern/tern" "$@"
  '';

  extraInstallCommands = ''
    mkdir --parents "$out/share/applications"
    substitute ${desktopItem}/share/applications/tern.desktop \
      "$out/share/applications/tern.desktop" \
      --replace-fail "Exec=tern" "Exec=$out/bin/tern"
  '';

  meta = {
    description = "FHS launcher for a user-managed Tern binary";
    homepage = "https://stencil.so";
    license = lib.licenses.unlicense;
    mainProgram = "tern";
    platforms = [ "x86_64-linux" ];
  };
}
