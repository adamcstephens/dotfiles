{
  inputs,
  withSystem,
  ...
}: let
  homeProfiles = {
    darwin-vm = {
      homeSystem = "aarch64-linux";
      modules = [
        ../apps/emacs
        ./linux-gui.nix
      ];
    };
    EMAT-C02G44CPQ05P = {
      username = "astephe9";
      homeSystem = "aarch64-darwin";
      modules = [
        ../apps/emacs
      ];
    };
    nixos2 = {
      homeSystem = "x86_64-linux";
      modules = [
        ../apps/emacs
      ];
    };
    sank = {
      homeSystem = "x86_64-linux";
      modules = [
        ../apps/emacs
        ./linux-gui.nix
      ];
      dotfiles = {
        isNixos = true;
        isVM = true;
        windowManager.hyprland = true;
      };
    };
    think = {
      homeSystem = "x86_64-linux";
      modules = [
        ../apps/emacs
        ./linux-gui.nix
      ];
      dotfiles = {
        windowManager.river = true;
      };
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
    dotfiles ? {},
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

        hmModules =
          [
            ./dotfiles.nix
            {
              inherit dotfiles;
            }
            ./home.nix
            inputs.doom-emacs.hmModule
            {
              home.username = username;
              home.homeDirectory = homeDir;
            }
          ]
          ++ modules
          ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [./darwin.nix])
          ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [./linux.nix]);
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
  flake.homeConfigurations = builtins.mapAttrs (name: value: (homeProfile value).homeConfig) homeProfiles;
  flake.homeModules = builtins.mapAttrs (name: value: (homeProfile value).homeModules) homeProfiles;
  flake.lib.findHome = hostname: system:
    if (builtins.elem hostname (builtins.attrNames homeProfiles))
    then hostname
    else system;
}
