{
  inputs,
  mkShell,
  pkgs,
}:
let
  pkgs' = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  ocamlPackages = pkgs'.ocaml-ng.ocamlPackages_5_4;
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
