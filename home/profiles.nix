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
    blank = {
      modules = [
        ./core-dev.nix
        (
          { pkgs, ... }:
          {
            home.packages = [
              self.packages.${pkgs.stdenv.hostPlatform.system}.wakey
            ];
          }
        )
      ];
    };

    agents = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-dev.nix
        {
          dotfiles.apps.agents.enable = true;
        }
      ];
    };

    core-dev = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-dev.nix
      ];
    };

    branch = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-dev.nix
      ];
    };

    deck = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;

      modules = [
        ./core-dev.nix
        ./linux-gui.nix

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

          # dotfiles.apps.waybar.battery = "upower";
          programs.waybar.settings.main.network.format-disconnected = "";

          services.lorri.enable = true;
        }
      ];
    };

    leaf = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-dev.nix
      ];
    };

    kale = {
      modules = [
        ./core-dev.nix
      ];
    };

    maple = {
      system = "aarch64-darwin";
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-darwin.nix
        (
          { config, pkgs, ... }:
          {
            dotfiles.apps = {
              agents.enable = true;
            };
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

    nixos2 = {
      system = "aarch64-linux";
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-dev.nix
        # ./linux-gui.nix
        # {
        #   dotfiles = {
        #     gui = {
        #       dpi = 120;
        #       wayland.enable = true;
        #     };
        #   };
        #
        #   services.kanshi.settings = [
        #     {
        #       profile.name = "virtual";
        #       profile.outputs = [
        #         {
        #           criteria = "Virtual-1";
        #           mode = "3840x2160";
        #           status = "enable";
        #           scale = 1.333333;
        #         }
        #       ];
        #     }
        #   ];
        # }
      ];
    };

    punk = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;

      modules = [
        ./linux-gui.nix

        {
          apps.ssh.tpm = true;

          dotfiles = {
            apps = {
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

    willow = {
      username = "adam";
      system = "aarch64-darwin";
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-darwin.nix
        (
          { pkgs, ... }:
          {
            dotfiles.apps.agents.enable = true;
            home.packages = [
              pkgs.e1s
              pkgs.terraform-mcp-server
              pkgs.typescript-language-server
            ];
          }
        )
      ];
    };

    worker1 = {
      modules = [
        ./core-dev.nix
      ];
    };

    dev-x86_64-linux = {
      system = "aarch64-linux";
      modules = [
        ./core-dev.nix
      ];
    };

    dev-aarch64-linux = {
      system = "aarch64-linux";
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
  flake.dotfiles.findHome =
    hostname: system: if (builtins.elem hostname (builtins.attrNames cfgs)) then hostname else system;
}
