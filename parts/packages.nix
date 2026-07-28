{ inputs, self, ... }:
{

  perSystem =
    {
      inputs',
      lib,
      pkgs,
      self',
      ...
    }:
    let
      pkgs-unstable = inputs'.nixpkgs.legacyPackages;
    in
    {
      packages =
        let
          ocamlPackages = pkgs-unstable.ocaml-ng.ocamlPackages_5_5;
        in
        lib.filesystem.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = ../packages;
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin (
          lib.filesystem.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage;
            directory = ../packages-darwin;
          }
        )
        // {
          default = self'.packages.dotfiles;

          dotfiles = pkgs-unstable.callPackage ../packages/dotfiles.nix {
            inherit ocamlPackages;
          };
        };
    };
}
