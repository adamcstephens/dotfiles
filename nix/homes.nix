{
  inputs,
  lib,
  withSystem,
  ...
}: let
  homeProfiles = {
    darwin-vm = {
      homeSystem = "aarch64-linux";
    };
    bonk = {
      homeSystem = "x86_64-darwin";
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
        ../apps/goldencheetah
        ../apps/emacs
        {
          dotfiles.gui.dpi = 148;
        }
      ];
    };
    drink = {
      homeSystem = "x86_64-linux";
      dotfiles.linuxGui = true;
      modules = [
        ../apps/goldencheetah
        {
          dotfiles.gui.insecure = true;
          home.sessionVariables = {
            LIBVA_DRIVER_NAME = "i965";
          };
          programs.firefox.enable = true;
          programs.firefox.profiles = {
            default = {
              id = 0;
              settings = {
                "media.ffmpeg.vaapi.enabled" = true;
                "media.ffvpx.enabled" = false;
                "media.av1.enabled" = false;
                "gfx.webrender.all" = true;
              };
            };
          };
        }
      ];
    };
    think = {
      homeSystem = "x86_64-linux";
      dotfiles.linuxGui = true;
      modules = [
        ../apps/goldencheetah
        ../apps/emacs
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
    x86_64-darwin = {
      homeSystem = "x86_64-darwin";
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

        hmModules =
          [
            ./dotfiles.nix
            ./home.nix
            inputs.nix-colors.homeManagerModule
            {
              # colorScheme = inputs.nix-colors.colorSchemes.ayu-dark;
              colorScheme = {
                slug = "modus-vivendi";
                name = "Modus Vivendi";
                author = "https://git.sr.ht/~protesilaos/modus-themes";
                colors = {
                  base00 = "#000000";
                  base01 = "#100323";
                  base02 = "#3C3C3C";
                  base03 = "#595959";
                  base04 = "#BEBCBF";
                  base05 = "#FFFFFF";
                  base06 = "#EDEAEF";
                  base07 = "#FFFFFF";
                  base08 = "#FF8059";
                  base09 = "#EF8B50";
                  base0A = "#D0BC00";
                  base0B = "#44BC44";
                  base0C = "#00D3D0";
                  base0D = "#2FAFFF";
                  base0E = "#FEACD0";
                  base0F = "#B6A0FF";
                };
              };
              home.username = username;
              home.homeDirectory = homeDir;
              nix.registry.nixpkgs.flake = lib.mkDefault inputs.nixpkgs;
            }
          ]
          ++ modules
          ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [./home-darwin.nix])
          ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [./home-linux.nix])
          ++ (pkgs.lib.optionals dotfiles.linuxGui [./linux-gui.nix]);
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
