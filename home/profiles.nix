{
  config,
  inputs,
  lib,
  self,
  ...
}: let
  cfgs = config.profile-parts.home-manager;
in {
  imports = [
    inputs.profile-parts.flakeModules.home-manager
  ];

  profile-parts.default.home-manager = {
    inherit (inputs) home-manager nixpkgs;

    username = "adam";
    exposePackages = true;
  };

  profile-parts.global.home-manager = {
    modules = {
      name,
      profile,
    }: [
      ./core.nix
      {
        _module.args.pkgs = lib.mkForce (import profile.nixpkgs {
          inherit (profile) system;
          overlays = [self.overlays.default self.overlays.upstreams];
          config.allowUnfree = true;
        });
      }
    ];

    specialArgs = {inherit inputs;};
  };

  profile-parts.home-manager = {
    blank = {
      modules = [
        ./linux-gui.nix
        ../apps/solaar

        ({pkgs, ...}: {
          dotfiles.apps.emacs.package = pkgs.emacs29-pgtk;
          dotfiles.gui = {
            dpi = 148;
            dontSuspend = true;
            wayland = true;
            xorg = true;
          };

          services.swayidle.timeouts = [
            {
              timeout = 960;
              command = lib.getExe (pkgs.writeScriptBin "output-resume" ''
                #!${lib.getExe pkgs.bash}
                ${lib.getExe pkgs.wlopm} --off HDMI-A-1
              '');
              resumeCommand = lib.getExe (pkgs.writeScriptBin "output-resume" ''
                #!${lib.getExe pkgs.bash}
                ${lib.getExe pkgs.wlopm} --on HDMI-A-1
                /run/current-system/sw/bin/systemd-run --user --on-active=1 /run/current-system/sw/bin/systemctl --user restart kanshi
              '');
            }
          ];
        })
      ];
    };

    drink = {
      modules = [
        ./linux-gui.nix
        ../apps/firefox
        ../apps/goldencheetah
        {
          dotfiles.gui.insecure = true;
          home.sessionVariables = {
            LIBVA_DRIVER_NAME = "i965";
          };
          dotfiles.gui.xorg = true;
        }
      ];
    };

    EMAT-C02G44CPQ05P = {
      username = "astephe9";
      system = "aarch64-darwin";
      modules = [./core-darwin.nix];
    };

    think = {
      modules = [
        ./linux-gui.nix
        ../apps/goldencheetah

        ({pkgs, ...}: {
          dotfiles = {
            apps.emacs.package = pkgs.emacs29-pgtk;
            apps.river.package = pkgs.river.overrideAttrs (_: rec {
              version = "0.3.0-${builtins.substring 0 7 src.rev}";
              src = pkgs.fetchFromGitHub {
                owner = "riverwm";
                repo = "river";
                rev = "7f30c655c75568ae331ed0243578d91870f3f9c6";
                fetchSubmodules = true;
                hash = "sha256-7cYLP2FID/DW4A06/Ujtqp2LE7NlHwaymQLiIA8xrMk=";
              };
            });
            gui.wayland = true;
          };
          programs.waybar.settings.main.output = ["eDP-1" "DP-2"];
        })
      ];
    };

    # generic systems

    aarch64-darwin = {
      system = "aarch64-darwin";
      modules = [./core-darwin.nix];
    };

    aarch64-linux = {
      system = "aarch64-linux";
    };

    x86_64-linux = {};
  };

  flake.homeModules = builtins.mapAttrs (_: profile: profile.finalModules) cfgs;
  flake.lib.findHome = hostname: system:
    if (builtins.elem hostname (builtins.attrNames cfgs))
    then hostname
    else system;
}
