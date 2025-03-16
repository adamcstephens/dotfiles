{
  inputs,
  mkShell,
  pkgs,
}:
let
  pkgs' = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  ocamlPackages = pkgs'.ocaml-ng.ocamlPackages_5_3;
in
mkShell {
  packages = [
    ocamlPackages.ocaml
    ocamlPackages.dune_3
    ocamlPackages.ocamlformat
    ocamlPackages.ocaml-lsp
    ocamlPackages.odig
    ocamlPackages.utop
    pkgs'.opam
    ocamlPackages.ocamlscript
  ];
  nativeBuildInputs = [
    ocamlPackages.fileutils
  ];
}
