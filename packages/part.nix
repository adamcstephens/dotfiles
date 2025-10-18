{ inputs, self, ... }:
{

  perSystem =
    { lib, pkgs, ... }:
    {
      packages =
        let
          ocamlPackages =
            if pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64 then
              inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.pkgsMusl.ocaml-ng.ocamlPackages_5_3
            else
              inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.ocaml-ng.ocamlPackages_5_3;
        in
        (
          lib.filesystem.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage;
            directory = ./.;
          }
          |> lib.filterAttrs (n: _: n != "part")
        )
        // rec {
          default = dotfiles;

          dotfiles = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.callPackage ./dotfiles.nix {
            inherit ocamlPackages;
            static = pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64;
          };

          hm = pkgs.callPackage ./hm.nix { inherit home-profile-selector; };

          home-profile-selector = pkgs.callPackage ./home-profile-selector.nix {
            homeConfigurations = builtins.attrNames self.homeConfigurations;
          };
        };
    };
}
