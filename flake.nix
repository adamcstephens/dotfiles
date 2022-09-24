{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    emacs.url = "github:nix-community/emacs-overlay";
    emacs.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    webcord.url = "github:fufexan/webcord-flake";
    webcord.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit self;} {
      imports = [
        ./nix/homes.nix
      ];

      systems = ["x86_64-linux" "aarch64-darwin"];

      perSystem = {
        pkgs,
        system,
        self',
        ...
      }: {
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          overlays = [self.inputs.emacs.overlay];
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.cachix
            pkgs.earthly
            pkgs.elixir
            pkgs.python3Minimal
          ];
        };

        packages = import ./nix/hm.nix {
          inherit pkgs self';
          homeConfigurations = self.homeConfigurations;
        };
      };
    };
}
