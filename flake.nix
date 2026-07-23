{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unstable-small.url = "github:nixos/nixpkgs?ref=nixos-unstable-small";

    hjem.url = "github:feel-co/hjem";
    hjem.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    epi.url = "git+https://tangled.org/adam.robins.wtf/epi";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mnw.url = "github:Gerg-L/mnw";
    nbac.inputs.nix-darwin.follows = "nix-darwin";
    nbac.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nbac.url = "git+https://tangled.org/adam.robins.wtf/nbac";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    profile-parts.url = "git+https://tangled.org/adam.robins.wtf/profile-parts";
    sower.url = "git+https://tangled.org/adam.robins.wtf/sower";
    vein.url = "git+https://tangled.org/adam.robins.wtf/vein";
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./apps/neovim/part.nix
        ./darwin/part.nix
        ./devshells/part.nix
        ./hjem/part.nix
        ./home/profiles.nix
        ./ocamlPackages/part.nix
        ./parts/epi.nix
        ./parts/overlays.nix
        ./parts/packages.nix
        ./templates/part.nix

        inputs.sower.flakeModules.sower
      ];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      flake.lib = inputs.nixpkgs.lib;
    };
}
