{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    mnw.url = "github:Gerg-L/mnw";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.flake-parts.follows = "flake-parts";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    profile-parts.url = "git+https://codeberg.org/adamcstephens/profile-parts";
    sower.url = "git+https://codeberg.org/adamcstephens/sower.git?ref=release-4";
    sower-next.url = "git+https://codeberg.org/adamcstephens/sower.git?ref=main";
  };

  outputs =
    { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./apps/neovim/part.nix
        ./devshells/part.nix
        ./home/profiles.nix
        ./ocamlPackages/part.nix
        ./parts/darwin.nix
        ./parts/overlays.nix
        ./parts/packages.nix
        ./templates/part.nix

        inputs.sower.flakeModules.seed
        inputs.sower-next.flakeModules.sower
      ];

      # helpful for limiting seed building until seed-ci has better options
      # sower.seed.buildOutputs = [ ];
      # flake.sower.home-manager.think.systems = [ "x86_64-linux" ];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      flake.lib = inputs.nixpkgs.lib;
    };
}
