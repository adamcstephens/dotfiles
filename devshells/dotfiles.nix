{
  inputs,
  lib,
  mkShell,
  pkgs,
}:
let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_4;
in
mkShell {
  name = "dots";

  packages = [
    inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.hjem
    pkgs.gitMinimal
    pkgs.just
    pkgs.niks3
    pkgs.npins
    pkgs.nix-update

    pkgs.ruff
    pkgs.ty

    ocamlPackages.dune_3
    ocamlPackages.ocamlformat
    ocamlPackages.ocaml-lsp
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    inputs.epi.packages.${pkgs.stdenv.hostPlatform.system}.epi
    inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.sower
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
    pkgs.nh
  ];
}
