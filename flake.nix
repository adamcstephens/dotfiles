{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    ironbar.url = "github:JakeStanger/ironbar";
    ironbar.inputs.nixpkgs.follows = "nixpkgs-unstable";
    mnw.url = "github:Gerg-L/mnw";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    profile-parts.url = "git+https://codeberg.org/adamcstephens/profile-parts";
    sandbox.url = "git+https://codeberg.org/adamcstephens/nix-sandbox";
    sandbox.inputs.nixpkgs.follows = "nixpkgs";
    sandbox.inputs.sower.follows = "sower";
    sower.url = "git+https://codeberg.org/adamcstephens/sower.git?ref=release-4";
  };

  outputs =
    { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./apps/neovim/part.nix
        ./devshells/part.nix
        ./home/profiles.nix
        ./templates/part.nix

        ./parts/darwin.nix
        ./parts/overlays.nix

        inputs.sower.flakeModules.seed
      ];

      # helpful for limiting seed building until seed-ci has better options
      # sower.seed.buildOutputs = [ ];
      # flake.sower.home-manager.think.systems = [ "x86_64-linux" ];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      perSystem =
        { lib, pkgs, ... }:
        {
          packages = import ./packages {
            inherit inputs lib pkgs;
            homeConfigurations = builtins.attrNames self.homeConfigurations;
          };
        };
    };
}
