{
  config,
  inputs,
  lib,
  self,
  ...
}:
let
  cfgs = config.profile-parts.home-manager;

  npins = import ../npins;
in
{
  imports = [ inputs.profile-parts.flakeModules.home-manager ];

  profile-parts.default.home-manager = {
    inherit (inputs) home-manager nixpkgs;

    username = lib.mkDefault "adam";
    exposePackages = true;
  };

  profile-parts.global.home-manager = {
    modules =
      { name, profile }:
      [
        inputs.nix-doom-emacs-unstraightened.hmModule
        ./core.nix
        (
          { pkgs, ... }:
          {
            dotfiles = {
              profile = name;

              gui.wayland.locker = self.packages.${pkgs.system}.dotfiles.overrideAttrs (_: {
                meta.mainProgram = "wayland-locker";
              });
            };

            home.packages = [
              self.packages.${pkgs.system}.dotfiles
            ];

            nix.registry.nixpkgs.flake = lib.mkDefault profile.nixpkgs;

            nixpkgs = {
              overlays = [
                self.overlays.default
                self.overlays.dotfiles
                self.overlays.upstreams
              ];

              config.allowUnfreePredicate =
                pkg:
                builtins.elem (lib.getName pkg) [
                  "1password"
                  "1password-cli"
                  "datagrip"
                  "vscode"
                  "vscode-extension-github-copilot"
                  "vscode-extension-ms-vsliveshare-vsliveshare"
                ];
            };

            services.sower.client.config.name = name;
          }
        )
      ];

    specialArgs = {
      inherit inputs npins;
      flake = self;
    };
  };

  profile-parts.home-manager = {
    deck = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;

      modules = [
        ./core-dev.nix
        ./linux-gui.nix

        {
          dotfiles = {
            apps.zk.enable = true;
            gui = {
              dpi = 148;
              dontSleep = true;
              wayland.enable = true;
            };
          };

          # dotfiles.apps.waybar.battery = "upower";
          programs.waybar.settings.main.network.format-disconnected = "";
        }
      ];
    };

    maple = {
      system = "aarch64-darwin";
      nixpkgs = inputs.nixpkgs-unstable-small;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-darwin.nix
        ../apps/postgresql
        (
          { config, pkgs, ... }:
          {
            dotfiles.apps.zk.defaultNotebook = "${config.home.homeDirectory}/git/calmwave/notebook";

            home.packages = [
              pkgs.docker
              pkgs.entr
              pkgs.git-lfs
              pkgs.terraform-lsp
            ];

            xdg.configFile."direnv/direnv.toml".text = ''
              [whitelist]
              prefix = [ "~/git/calmwave/cw" ]
            '';
          }
        )
      ];
    };

    nix-community-aarch64-linux = {
      system = "aarch64-linux";
      modules = [
        {
          home.username = "adamcstephens";
          home.homeDirectory = "/home/adamcstephens";
          apps.sower.enable = false;
        }
      ];
    };

    nixos2 = {
      system = "aarch64-linux";
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-dev.nix
      ];
    };

    seek = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;

      modules = [
        ./linux-gui.nix

        (
          { pkgs, ... }:
          {
            apps.ssh.tpm = true;

            dotfiles = {
              apps.zk.enable = true;
              gui = {
                dpi = 120;
                wayland.enable = true;
              };
            };

            programs.waybar.settings.main = {
              network.interface = "wlp1s0";
            };

            services.kanshi.settings = [
              {
                profile.name = "undocked";
                profile.outputs = [
                  {
                    criteria = "eDP-1";
                    mode = "2880x1800@60Hz";
                    scale = 1.5;
                    status = "enable";
                  }
                ];
              }
            ];
          }
        )
      ];
    };

    worker1 = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;

      modules = [
        ./core-dev.nix
      ];
    };

    # generic systems

    aarch64-darwin = {
      system = "aarch64-darwin";
      modules = [ ./core-darwin.nix ];
    };

    aarch64-linux = {
      system = "aarch64-linux";
    };

    x86_64-linux = { };
  };

  flake.homeModules = builtins.mapAttrs (_: profile: profile.finalModules) cfgs;
  flake.lib.findHome =
    hostname: system: if (builtins.elem hostname (builtins.attrNames cfgs)) then hostname else system;
}
