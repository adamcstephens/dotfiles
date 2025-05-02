{ mkShell, pkgs }:
let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_3;
in
mkShell {
  name = "dots";

  packages = [
    # local only
    pkgs.attic-client
    # ocamlPackages.ocaml
    ocamlPackages.dune_3
    ocamlPackages.ocamlformat
    ocamlPackages.ocaml-lsp
  ];
}
