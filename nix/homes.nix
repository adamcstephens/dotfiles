{
  inputs,
  lib,
  withSystem,
  ...
}: let
  homeProfiles = {
    darwin-vm = {
      homeSystem = "aarch64-linux";
      dotfiles.linuxGui = true;
    };
    EMAT-C02G44CPQ05P = {
      username = "astephe9";
      homeSystem = "aarch64-darwin";
      modules = [
        ../apps/emacs
      ];
    };
    blank = {
      homeSystem = "x86_64-linux";
      dotfiles.linuxGui = true;
      modules = [
        {
          dotfiles.gui.dpi = 148;
        }
      ];
    };
    think = {
      homeSystem = "x86_64-linux";
      dotfiles.linuxGui = true;
      modules = [
        {
          dotfiles.gui.dpi = 196;
        }
      ];
    };

    # generic systems
    aarch64-darwin = {
      homeSystem = "aarch64-darwin";
    };
    x86_64-linux = {
      homeSystem = "x86_64-linux";
    };
    aarch64-linux = {
      homeSystem = "aarch64-linux";
    };
  };

  homeProfile = {
    username ? "adam",
    modules ? [],
    dotfiles ? {linuxGui = false;},
    homeSystem,
  }:
    withSystem homeSystem (
      {
        inputs',
        pkgs,
        self',
        system,
        ...
      }: let
        homeDir =
          if pkgs.stdenv.isDarwin
          then "/Users/${username}"
          else "/home/${username}";

        cliPkgs = [
          inputs.comma.packages.${system}.comma
          pkgs.terminfo
        ];
        guiPkgs = [
          inputs.webcord.packages.${system}.default
        ];

        hmModules =
          [
            ./dotfiles.nix
            {
              inherit dotfiles;
              nix.registry.nixpkgs.flake = lib.mkDefault inputs.nixpkgs;
            }
            ./home.nix
            {
              home.username = username;
              home.homeDirectory = homeDir;
            }
            {
              # install packages from the dotfiles flake
              home.packages = cliPkgs;
            }
            inputs.nix-colors.homeManagerModule
            {
              # colorScheme = inputs.nix-colors.colorSchemes.circus;
              colorScheme = inputs.nix-colors.colorSchemes.ayu-dark;
              # colorScheme = inputs.nix-colors.colorSchemes.cupertino;
            }
          ]
          ++ modules
          ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [./home-darwin.nix])
          ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [./home-linux.nix])
          ++ (pkgs.lib.optionals dotfiles.linuxGui [
            ../apps/emacs
            ./linux-gui.nix
            {
              # install packages from the dotfiles flake
              home.packages = guiPkgs;
            }
          ]);
      in {
        homeConfig = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = hmModules;

          extraSpecialArgs = {
            inherit inputs inputs' self' system;
          };
        };

        homeModules = hmModules;
      }
    );
in {
  flake.homeConfigurations = builtins.mapAttrs (_: value: (homeProfile value).homeConfig) homeProfiles;
  flake.homeModules = builtins.mapAttrs (_: value: (homeProfile value).homeModules) homeProfiles;
  flake.lib.findHome = hostname: system:
    if (builtins.elem hostname (builtins.attrNames homeProfiles))
    then hostname
    else system;
}
