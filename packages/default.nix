{
  inputs,
  lib,
  pkgs,
  homeConfigurations,
  ...
}:
let
  ocamlPackages =
    if pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64 then
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.pkgsMusl.ocaml-ng.ocamlPackages_5_3
    else
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.ocaml-ng.ocamlPackages_5_3;

  wasm-nixpkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    crossSystem = lib.systems.examples.wasi32 // {
      rust.rustcTarget = "wasm32-wasip1";
    };
  };
in
(lib.filesystem.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage;
  directory = ./.;
})
// rec {
  default = dotfiles;
  dotfiles = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.callPackage ./dotfiles.nix {
    inherit ocamlPackages;
    static = pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64;
  };
  hm = pkgs.callPackage ./hm.nix { inherit home-profile-selector; };
  home-profile-selector = pkgs.callPackage ./home-profile-selector.nix {
    inherit homeConfigurations;
  };
}
