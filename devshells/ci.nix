{
  inputs,
  lib,
  pkgs,
  mkShellNoCC,
}:
mkShellNoCC {
  name = "ci";
  packages = [
    pkgs.attic-client
    pkgs.git
    pkgs.just
    pkgs.niks3
    pkgs.ntfy-sh
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    inputs.sower-next.packages.${pkgs.stdenv.hostPlatform.system}.cli
  ];
}
