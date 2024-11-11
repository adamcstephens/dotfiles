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

    username = "adam";
    exposePackages = true;
  };

  profile-parts.global.home-manager = {
    modules =
      { name, profile }:
      [
        ./core.nix
        {
          nix.registry.nixpkgs.flake = lib.mkDefault profile.nixpkgs;

          nixpkgs = {
            overlays = [
              self.overlays.default
              self.overlays.upstreams
            ];

            config.allowUnfreePredicate =
              pkg:
              builtins.elem (lib.getName pkg) [
                "1password"
                "1password-cli"
                "aspell-dict-en-science"
                "vscode"
                "vscode-extension-github-copilot"
                "vscode-extension-ms-vsliveshare-vsliveshare"
              ];
          };

          services.sower.client.config.name = name;
        }
      ];

    specialArgs = {
      inherit inputs npins;
      flake = self;
    };
  };

  profile-parts.home-manager = {
    blank = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;

      modules = [
        ./linux-gui.nix
        # ../apps/solaar

        (
          { pkgs, ... }:
          {
            dotfiles.gui = {
              dpi = 148;
              dontSleep = true;
              drmDevices = [
                "/dev/dri/card1"
              ];
              wayland = true;
              xorg = {
                enable = true;
                wm = "xmonad";
              };
            };

            dotfiles.apps.waybar.battery = "upower";
            programs.waybar.settings.main.network.format-disconnected = "";

            services.grobi = {
              enable = true;
              rules = [
                {
                  name = "desktop";
                  outputs_connected = [ "HDMI-1" ];
                  configure_single = "HDMI-1";
                  primary = true;
                  atomic = true;
                  execute_after = [
                    "/run/current-system/sw/bin/systemd-run --user --on-active=5s ${lib.getExe pkgs.xorg.xset} r rate 160 80"
                  ];
                }
              ];
            };
            systemd.user.services.grobi = {
              Install.WantedBy = lib.mkForce [ "xserver-session.target" ];
              Unit.PartOf = lib.mkForce [ "xserver-session.target" ];
            };

            services.swayidle.timeouts = [
              {
                timeout = 960;
                command = lib.getExe (
                  pkgs.writeShellScriptBin "output-resume" ''
                    ${lib.getExe pkgs.wlopm} --off HDMI-A-1
                  ''
                );
                resumeCommand = lib.getExe (
                  pkgs.writeShellScriptBin "output-resume" ''
                    ${lib.getExe pkgs.wlopm} --on HDMI-A-1
                    /run/current-system/sw/bin/systemd-run --user --on-active=1 /run/current-system/sw/bin/systemctl --user restart kanshi
                  ''
                );
              }
            ];
          }
        )
      ];
    };

    dev1 = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-dev.nix
        {
          dotfiles.dev.enable = true;
        }
      ];
    };

    maple = {
      system = "aarch64-darwin";
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
      modules = [
        ./core-darwin.nix
        ../apps/postgresql
        (
          { pkgs, ... }:
          {
            home.packages = [
              inputs.devbox.packages.${pkgs.system}.default
              pkgs.elixir-ls
              pkgs.next-ls
              pkgs.pgcli
              (pkgs.python3.withPackages (
                ps: with ps; [
                  python-lsp-server
                  pylsp-mypy
                ]
              ))
              pkgs.watchexec
            ];
            nix.package = lib.mkForce pkgs.nixVersions.latest;
          }
        )
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
              apps = {
                vscode.enable = true;
                vscodium.enable = false;
              };

              gui = {
                dpi = 120;
                wayland = true;

                xorg = {
                  enable = true;
                  wm = "xmonad";
                };
              };
            };

            programs.waybar.settings.main = {
              network.interface = "wlp1s0";
            };

            services.grobi = {
              enable = true;
              rules = [
                {
                  name = "docked";
                  outputs_connected = [
                    "DP-6"
                    "eDP-1"
                  ];
                  configure_single = "DP-6";
                  primary = true;
                  atomic = true;
                  execute_after = [
                    "/run/current-system/sw/bin/systemd-run --user --on-active=5s ${lib.getExe pkgs.xorg.xset} r rate 160 80"
                  ];
                }
                {
                  name = "docked";
                  outputs_connected = [
                    "DP-5"
                    "eDP-1"
                  ];
                  configure_single = "DP-5";
                  primary = true;
                  atomic = true;
                  execute_after = [
                    "/run/current-system/sw/bin/systemd-run --user --on-active=5s ${lib.getExe pkgs.xorg.xset} r rate 160 80"
                  ];
                }
                {
                  name = "undocked";
                  outputs_connected = [ "eDP-1" ];
                  configure_single = "eDP-1";
                  primary = true;
                  atomic = true;
                  execute_after = [
                    "/run/current-system/sw/bin/systemd-run --user --on-active=5s ${lib.getExe pkgs.xorg.xset} r rate 160 80"
                  ];
                }
              ];
            };

            services.kanshi.profiles.undocked = lib.mkForce {
              outputs = [
                {
                  criteria = "eDP-1";
                  mode = "2880x1800@60Hz";
                  scale = 1.5;
                  status = "enable";
                }
              ];
            };
          }
        )
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
