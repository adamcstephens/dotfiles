{
  mkShell,
  pkgs,
}:
mkShell {
  packages = [
    pkgs.ocaml
    pkgs.ocamlPackages.dune_3
    pkgs.ocamlPackages.ocamlformat
    pkgs.ocamlPackages.ocaml-lsp
    pkgs.ocamlPackages.odig
    pkgs.ocamlPackages.utop
    pkgs.opam
  ];
}
