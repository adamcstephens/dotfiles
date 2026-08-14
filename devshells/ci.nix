{
  inputs,
  lib,
  pkgs,
  mkShellNoCC,
}:
mkShellNoCC {
  name = "ci";
  packages = [
    pkgs.git
    pkgs.just
    pkgs.niks3
    pkgs.ntfy-sh
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.sower
  ];
}
