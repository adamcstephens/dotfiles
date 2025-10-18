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
              pkgs-unstable.pkgsMusl.ocaml-ng.ocamlPackages_5_3
            else
              pkgs-unstable.ocaml-ng.ocamlPackages_5_3;
        in
        (lib.filesystem.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory =
            with lib.fileset;
            toSource {
              root = ./.;
              fileset = difference ./. ./part.nix;
            };
        })
        // {
          default = self'.packages.dotfiles;

          dotfiles = pkgs-unstable.callPackage ./dotfiles.nix {
            inherit ocamlPackages;
            static = pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64;
          };

          hm = pkgs.callPackage ./hm.nix { inherit (self'.packages) home-profile-selector; };

          home-profile-selector = pkgs.callPackage ./home-profile-selector.nix {
            homeConfigurations = builtins.attrNames self.homeConfigurations;
          };
        };
    };
}
