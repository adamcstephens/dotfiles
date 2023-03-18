{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    apple-fonts.url = "github:adamcstephens/apple-fonts.nix";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    emacs.url = "github:nix-community/emacs-overlay";
    emacs.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # home-manager.url = "github:nix-community/home-manager";
    home-manager.url = "github:adamcstephens/home-manager/zoxide/nushell";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-wallpaper.url = "github:lunik1/nix-wallpaper";
    nix-wallpaper.inputs.nixpkgs.follows = "nixpkgs";
    sandbox.url = "github:adamcstephens/nix-sandbox";
    sandbox.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./parts/home.nix
        ./home/configs.nix

        ./parts/darwin.nix
      ];

      systems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];

      perSystem = {
        lib,
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
          config.allowUnfree = true;
        };

        devShells = {
          default = pkgs.mkShellNoCC {
            name = "dots";
            packages =
              [
                pkgs.alejandra
                pkgs.just
                pkgs.nil
                pkgs.nodePackages.prettier
              ]
              ++ (lib.optionals pkgs.stdenv.isLinux [
                (pkgs.ghc.withPackages (ps: [
                  ps.haskell-language-server
                  ps.ormolu
                  ps.xmonad
                  ps.xmonad-contrib
                ]))
              ]);
          };
          miryoku_kmonad = pkgs.mkShell {
            name = "miryoku_kmonad";
            packages = [
              pkgs.gnumake
              pkgs.gnused
            ];
          };
          nixpkgs = pkgs.mkShellNoCC {
            packages =
              [
                pkgs.nixpkgs-review
                pkgs.deadnix
              ]
              ++ (lib.optionals pkgs.stdenv.isLinux [
                pkgs.bubblewrap
              ]);
          };
        };

        packages = import ./packages {
          inherit pkgs;
          homeConfigurations = builtins.attrNames self.homeConfigurations;
        };
      };
    }
    // {
      overlays = rec {
        default = inputs.nixpkgs.lib.composeManyExtensions [
          inputs.emacs.overlays.emacs
          inputs.emacs.overlays.package
          fishPlugins
        ];

        # disable tests since they broke on darwin...
        fishPlugins = _: prev: {
          fishPlugins = prev.fishPlugins.overrideScope' (_: fprev: {
            fzf-fish = fprev.fzf-fish.overrideAttrs (_: {
              doCheck = false;
            });
          });
        };
      };
    };
}
