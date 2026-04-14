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
      pkgs-unstable = inputs'.nixpkgs-unstable.legacyPackages;
    in
    {
      packages =
        let
          ocamlPackages =
            if pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64 then
              pkgs-unstable.pkgsMusl.ocaml-ng.ocamlPackages_5_4
            else
              pkgs-unstable.ocaml-ng.ocamlPackages_5_4;
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
            static = pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64;
          };

          hm = pkgs.callPackage ../packages/hm.nix { inherit (self'.packages) home-profile-selector; };

          home-profile-selector = pkgs.callPackage ../packages/home-profile-selector.nix {
            homeConfigurations = builtins.attrNames self.homeConfigurations;
          };
        };
    };
}
