{
  inputs = {
    nixpkgs.url = "github:adamcstephens/nixpkgs/atomix-unstable";

    attic.url = "github:zhaofengli/attic";
    emacs-plus.url = "github:d12frosted/homebrew-emacs-plus";
    emacs-plus.flake = false;
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    nil.url = "github:oxalica/nil";
    nil.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-wallpaper.url = "github:lunik1/nix-wallpaper";
    nix-wallpaper.inputs.nixpkgs.follows = "nixpkgs";
    profile-parts.url = "git+https://codeberg.org/adamcstephens/profile-parts";
    sandbox.url = "git+https://codeberg.org/adamcstephens/nix-sandbox";
    sandbox.inputs.nixpkgs.follows = "nixpkgs";
    sower.url = "git+https://codeberg.org/adamcstephens/sower";
    sower.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./devshells/part.nix
        ./home/profiles.nix

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
        {
          lib,
          pkgs,
          system,
          ...
        }:
        {
          packages = import ./packages {
            inherit inputs lib pkgs;
            homeConfigurations = builtins.attrNames self.homeConfigurations;
          };
        };
    };
}
