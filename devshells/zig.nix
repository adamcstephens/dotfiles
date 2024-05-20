{
  mkShell,

  pkg-config,
  wayland-protocols,
  wayland-scanner,
  zig_0_12,
}:
mkShell {
  packages = [
    pkg-config
    wayland-protocols
    wayland-scanner
    zig_0_12
  ];
}
