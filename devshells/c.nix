{
  mkShell,
  pkgs,
}:
mkShell {
  packages = [
    pkgs.autoconf
    pkgs.automake
    pkgs.binutils
    pkgs.cmake
    pkgs.gnumake
    pkgs.gcc
    pkgs.libtool
    pkgs.meson
    pkgs.ninja
    pkgs.mtools
    pkgs.perl
    pkgs.xz
  ];
}
