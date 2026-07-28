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
  };

  profile-parts.global.home-manager = {
    modules =
      { name, profile }:
      [
        ./core.nix
        (
          { pkgs, ... }:
          {
            dotfiles = {
              profile = name;

              gui.wayland.locker = self.packages.${pkgs.stdenv.hostPlatform.system}.dotfiles.overrideAttrs (_: {
                meta.mainProgram = "wayland-locker";
              });
            };

            home.packages = [
              self.packages.${pkgs.stdenv.hostPlatform.system}.dotfiles
            ];

            nix.registry.nixpkgs.flake = lib.mkDefault profile.nixpkgs;

            nixpkgs = {
              overlays = [
                self.overlays.dotfiles
              ];

              config.allowUnfreePredicate =
                pkg:
                builtins.elem (lib.getName pkg) [
                  "1password"
                  "1password-cli"
                  "datagrip"
                  "bws"
                ];
            };
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
      nixpkgs = inputs.nixpkgs;
      home-manager = inputs.home-manager-unstable;

      modules = [
        ./core-dev.nix
        ./linux-gui.nix

        (
          { pkgs, ... }:
          {
            dotfiles = {
              apps = {
                hypridle.enable = false;
                sower.enable = true;
                swayidle.enable = true;
                zk.enable = true;
              };
              gui = {
                dpi = 148;
                # autosuspend in nixos handles this
                dontSleep = true;
                wayland.enable = true;
              };
            };

            home.packages = [
              pkgs.sone
            ];

            # dotfiles.apps.waybar.battery = "upower";
            programs.waybar.settings.main.network.format-disconnected = "";

            services.lorri.enable = true;
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
        }
      ];
    };

    punk = {
      nixpkgs = inputs.nixpkgs;
      home-manager = inputs.home-manager-unstable;

      modules = [
        ./linux-gui.nix

        {
          apps.ssh.tpm = true;

          dotfiles = {
            apps = {
              sower.enable = true;
              zk.enable = true;
            };
            gui = {
              wayland.enable = true;
            };
          };

          programs.waybar.settings.main = {
            network.interface = "wlan0";
          };

          services.kanshi.settings = [
            {
              profile.name = "undocked";
              profile.outputs = [
                {
                  criteria = "eDP-1";
                  scale = 1.75;
                  status = "enable";
                }
              ];
            }
            {
              profile.name = "laptop-present";
              profile.outputs = [
                {
                  criteria = "HDMI-A-1";
                  mode = "1920x1080";
                }
                {
                  criteria = "eDP-1";
                  scale = 1.75;
                  status = "enable";
                }
              ];
            }
          ];
        }
      ];
    };
  };

  flake.homeModules = builtins.mapAttrs (_: profile: profile.finalModules) cfgs;
  flake.dotfiles.findHome =
    hostname: system: if (builtins.elem hostname (builtins.attrNames cfgs)) then hostname else system;
}
