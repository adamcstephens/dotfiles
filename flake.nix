{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
  }: let
    pkgs = nixpkgs.legacyPackages.aarch64-darwin;
  in {
    homeConfigurations.adam = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      
      modules = [
        (_: {
          home.username = "astephe9";
          home.homeDirectory = "/Users/astephe9";
          home.stateVersion = "22.05";
          
          programs.home-manager.enable = true;
          
          home.packages = [
            pkgs.alejandra
            pkgs.htop
          ];
        })
      ];
    };
  };
}
