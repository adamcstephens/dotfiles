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
    inputs.sower.packages.${pkgs.system}.seed-ci
    inputs.sower.packages.${pkgs.system}.client
  ];
}
