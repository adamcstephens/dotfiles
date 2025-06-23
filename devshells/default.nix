{ mkShell, pkgs }:
let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_3;
in
mkShell {
  name = "dots";

  packages = [
    pkgs.attic-client
    pkgs.nh
    pkgs.gitMinimal
    pkgs.just
    pkgs.nix-update
    pkgs.npins

    ocamlPackages.dune_3
    ocamlPackages.ocamlformat
    ocamlPackages.ocaml-lsp
  ];
}
