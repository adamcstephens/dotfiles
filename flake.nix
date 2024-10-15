{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    devbox.url = "github:jetify-com/devbox/latest";
    devbox.inputs.nixpkgs.follows = "nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mnw.url = "github:Gerg-L/mnw";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    nix-wallpaper.url = "github:lunik1/nix-wallpaper";
    nix-wallpaper.inputs.nixpkgs.follows = "nixpkgs";
    profile-parts.url = "git+https://codeberg.org/adamcstephens/profile-parts";
    sandbox.url = "git+https://codeberg.org/adamcstephens/nix-sandbox";
    sandbox.inputs.nixpkgs.follows = "nixpkgs";
    sandbox.inputs.sower.follows = "sower";
    sower.url = "git+https://codeberg.org/adamcstephens/sower?ref=release-3";
  };

  outputs =
    { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./apps/neovim/part.nix
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
        { lib, pkgs, ... }:
        {
          packages = import ./packages {
            inherit inputs lib pkgs;
            homeConfigurations = builtins.attrNames self.homeConfigurations;
          };
        };
    };
}
