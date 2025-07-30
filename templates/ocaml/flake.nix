{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable-small";

    flake-parts.url = "github:hercules-ci/flake-parts";
    sandbox.url = "git+https://git.junco.dev/adam/nix-sandbox";
    sandbox.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];

        perSystem =
          { pkgs, ... }:
          let
            ocamlPackages = inputs.sandbox.lib.ocamlOverride pkgs.ocaml-ng.ocamlPackages_5_2;
          in
          {
            devShells.default = pkgs.mkShell {
              packages =
                [
                  ocamlPackages.ocaml
                ]
                ++ (with ocamlPackages; [
                  dune_3
                  ocamlformat
                  ocaml-lsp
                  ocaml_openapi_generator
                  odig
                  utop
                ]);
            };

            packages = {
              default = pkgs.pkgsMusl.callPackage ./package.nix {
                ocamlPackages = inputs.sandbox.lib.ocamlOverride pkgs.pkgsMusl.ocaml-ng.ocamlPackages_5_2;
              };
            };
          };
      }
    );
}
