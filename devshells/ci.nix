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
    pkgs.ntfy-sh
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.cli
    inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.client
    inputs.sower-next.packages.${pkgs.stdenv.hostPlatform.system}.cli
  ];
}
