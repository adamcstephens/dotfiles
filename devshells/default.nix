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
    pkgs.attic-client
    pkgs.gitMinimal
    pkgs.just
    pkgs.nix-update
    pkgs.npins

    pkgs.ty

    ocamlPackages.dune_3
    ocamlPackages.ocamlformat
    ocamlPackages.ocaml-lsp
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    inputs.sower-next.packages.${pkgs.stdenv.hostPlatform.system}.cli
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.nh
  ];
}
