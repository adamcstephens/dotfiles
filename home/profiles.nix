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
          nixpkgs = {
            overlays = [
              self.overlays.default
              self.overlays.upstreams
            ];
            config.allowUnfree = true;
          };
        }
      ];

    specialArgs = {
      inherit inputs npins;
    };
  };

  profile-parts.home-manager = {
    ark = {
      system = "aarch64-linux";
      modules = [
        ./linux-gui.nix
        ../apps/goldencheetah

        (
          { pkgs, ... }:
          {
            dotfiles = {
              gui.wayland = true;
              gui.dpi = 144;
            };

            programs.waybar.settings.main = {
              output = [
                "eDP-1"
                "DP-1"
                "DP-2"
              ];
              network.interface = "wlP6p1s0";
            };

            # no gamma support on x13s
            services.gammastep.enable = lib.mkForce false;

            services.kanshi.profiles.undocked = lib.mkForce {
              outputs = [
                {
                  criteria = "eDP-1";
                  scale = 1.15;
                  status = "enable";
                }
              ];
            };

            services.ssh-agent.enable = true;
            systemd.user.services.ssh-agent.Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
            systemd.user.services.ssh-agent.Service.Environment = [
              "SSH_ASKPASS=${pkgs.x11_ssh_askpass}/libexec/ssh-askpass"
            ];
          }
        )
      ];
    };

    blank = {
      modules = [
        ./linux-gui.nix
        ../apps/solaar

        (
          { pkgs, ... }:
          {
            dotfiles.gui = {
              dpi = 148;
              dontSuspend = true;
              wayland = true;
              xorg = {
                enable = true;
                wm = "xmonad";
              };
            };

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
                    "/run/current-system/sw/bin/systemd-run --user --on-active=5s ${lib.getExe pkgs.xorg.xset} r rate 200 100"
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
                  pkgs.writeScriptBin "output-resume" ''
                    #!${lib.getExe pkgs.bash}
                    ${lib.getExe pkgs.wlopm} --off HDMI-A-1
                  ''
                );
                resumeCommand = lib.getExe (
                  pkgs.writeScriptBin "output-resume" ''
                    #!${lib.getExe pkgs.bash}
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

    drink = {
      enable = false;

      modules = [
        ./linux-gui.nix
        ../apps/firefox
        ../apps/goldencheetah
        {
          dotfiles.gui = {
            insecure = true;
            xorg.enable = true;
          };

          home.sessionVariables = {
            LIBVA_DRIVER_NAME = "i965";
          };
        }
      ];
    };

    EMAT-C02G44CPQ05P = {
      username = "astephe9";
      system = "aarch64-darwin";
      modules = [ ./core-darwin.nix ];
    };

    silver = {
      system = "aarch64-darwin";
      modules = [
        ./core-darwin.nix

        {
          dotfiles.apps.emacs = {
            patchForGui = false;
            full = false;
          };
        }
      ];
    };

    think = {
      modules = [
        ./linux-gui.nix
        ../apps/goldencheetah

        (
          { pkgs, ... }:
          {
            dotfiles = {
              gui.wayland = true;
            };

            programs.waybar.settings.main = {
              network.interface = "wlp0s20f3";
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

  flake.sower =
    let
      systemShells = lib.mapAttrs (on: ov: (lib.mapAttrs (n: v: n) ov)) self.devShells;
      allShells =
        lib.foldlAttrs
          (
            acc: n: v:
            acc
            ++
              builtins.map
                (dsv: {
                  name = dsv;
                  system = n;
                })
                (builtins.attrNames v)
          )
          [ ]
          systemShells;
      devShells =
        lib.foldl
          (
            acc: n:
            acc
            // {
              "${n.name}" = {
                systems = (acc.${n.name}.systems or [ ]) ++ [ n.system ];
              };
            }
          )
          { }
          allShells;
    in
    {
      dev-shell = devShells;
      darwin =
        lib.mapAttrs
          (n: v: {
            systems = [ v.pkgs.hostPlatform.system ];
          })
          self.darwinConfigurations;
      home-manager =
        lib.mapAttrs
          (n: v: {
            systems = [ v.pkgs.hostPlatform.system ];
          })
          self.homeConfigurations;
    };
}
