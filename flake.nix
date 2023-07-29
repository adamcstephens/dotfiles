{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    apple-fonts.url = "git+https://codeberg.org/adamcstephens/apple-fonts.nix";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-plus.url = "github:d12frosted/homebrew-emacs-plus";
    emacs-plus.flake = false;
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nil.url = "github:oxalica/nil";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-wallpaper.url = "github:lunik1/nix-wallpaper";
    nix-wallpaper.inputs.nixpkgs.follows = "nixpkgs";
    nixfmt-rfc.url = "github:piegamesde/nixfmt/rfc101-style";
    nixfmt-rfc.flake = false;
    profile-parts.url = "git+https://codeberg.org/adamcstephens/profile-parts";
    profile-parts.inputs.nixpkgs.follows = "nixpkgs";
    sandbox.url = "git+https://codeberg.org/adamcstephens/nix-sandbox";
    sandbox.inputs.nixpkgs.follows = "nixpkgs";
    wrapper-manager.url = "github:viperML/wrapper-manager";
    wrapper-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.profile-parts.flakeModules.home-manager
        ./parts/home.nix
        ./home/profiles.nix

        ./parts/darwin.nix
        ./parts/devshells.nix
        ./parts/overlays.nix
      ];

      systems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        packages = import ./packages {
          inherit pkgs;
          homeConfigurations = builtins.attrNames self.homeConfigurations;
        };
      };
    };
}
