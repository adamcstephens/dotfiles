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
    pkgs.nix-update
    pkgs.npins
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    inputs.sower.packages.${pkgs.system}.seed-ci
    inputs.sower.packages.${pkgs.system}.client
  ];
}
