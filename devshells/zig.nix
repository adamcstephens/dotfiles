{
  mkShell,

  pkg-config,
  wayland-protocols,
  wayland-scanner,
  zig,
}:
mkShell {
  packages = [
    pkg-config
    wayland-protocols
    wayland-scanner
    zig
  ];
}
