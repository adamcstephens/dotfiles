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
    pkgs.gitMinimal
    pkgs.just
    pkgs.niks3
    pkgs.nix-update
    pkgs.npins

    pkgs.ty

    ocamlPackages.dune_3
    ocamlPackages.ocamlformat
    ocamlPackages.ocaml-lsp
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    inputs.epi.packages.${pkgs.stdenv.hostPlatform.system}.epi
    inputs.sower-next.packages.${pkgs.stdenv.hostPlatform.system}.cli
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.nh
  ];
}
