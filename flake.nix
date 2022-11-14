{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    comma.url = "github:nix-community/comma";
    comma.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    emacs.url = "github:nix-community/emacs-overlay";
    emacs.inputs.nixpkgs.follows = "nixpkgs";
    eww.url = "github:elkowar/eww";
    eww.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    nixinate.url = "github:matthewcroughan/nixinate";
    webcord.url = "github:fufexan/webcord-flake";
    webcord.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit self;} {
      imports = [
        ./nix/homes.nix
        ./nix/darwin.nix
        ./nix/nixos-darwin-vm.nix
      ];

      systems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        };

        devShells.default = pkgs.mkShellNoCC {
          name = "dots";
          packages = [
            pkgs.cachix
            pkgs.just
            pkgs.python3Minimal
          ];
        };

        packages = import ./nix/packages {
          inherit pkgs;
          homeConfigurations = builtins.attrNames self.homeConfigurations;
        };
      };
    }
    // {
      apps = self.inputs.nixinate.nixinate.aarch64-darwin self;
      overlays = import ./nix/overlays.nix inputs;
    };
}
