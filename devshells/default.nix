{ mkShell, pkgs }:
let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_3;
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
  ];
}
