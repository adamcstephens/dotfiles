{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.profile-parts.flakeModules.darwin ];

  profile-parts.default.darwin = {
    inherit (inputs) nix-darwin nixpkgs;
    exposePackages = true;
  };

  profile-parts.global.darwin = {
    modules = [
      (inputs.nix-darwin.outPath + "/modules/nix/nix-darwin.nix") # install darwin-rebuild
      (
        { pkgs, ... }:
        {
          fonts = {
            fontDir.enable = true;
            fonts = [
              pkgs.font-awesome
              pkgs.ibm-plex
              pkgs.jetbrains-mono
              pkgs.material-icons
              pkgs.material-design-icons
              (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
            ];
          };
          nix = {
            gc = {
              automatic = true;
              interval = {
                Hour = 3;
                Minute = 15;
              };
              options = "--delete-older-than 21d";
            };

            settings = {
              auto-optimise-store = false;
              accept-flake-config = false;
              experimental-features = "nix-command flakes";

              trusted-users = [
                "root"
                "@admin"
              ];

              substituters = [ "https://cache.junco.dev/v3?priority=41" ];
              trusted-public-keys = [ "v3:aMXMnngJoGU8dpELPyNAhADrOgrn5GiXWP90NiB4aFY=" ];
              extra-platforms = "x86_64-darwin";
            };
          };

          services.nix-daemon.enable = true;

          system.defaults = {
            NSGlobalDomain = {
              InitialKeyRepeat = 15;
              KeyRepeat = 1;

              NSAutomaticCapitalizationEnabled = false;
              NSAutomaticDashSubstitutionEnabled = false;
              NSAutomaticPeriodSubstitutionEnabled = false;
              NSAutomaticQuoteSubstitutionEnabled = false;
              NSAutomaticSpellingCorrectionEnabled = false;
            };
            dock = {
              autohide = true;
              autohide-delay = 2.0;
              orientation = "left";
              showhidden = true;
              show-recents = false;
            };
            SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
          };

          time.timeZone = "America/New_York";

          # While it’s possible to set `nix.settings.auto-optimise-store`, it sometimes
          # causes problems on Darwin. So run a job periodically to optimise the store:
          # https://github.com/NixOS/nix/issues/7273
          launchd.daemons."nix-store-optimise".serviceConfig = {
            ProgramArguments = [
              "/bin/sh"
              "-c"
              ''
                /bin/wait4path ${pkgs.nix}/bin/nix && \
                  exec ${pkgs.nix}/bin/nix store optimise
              ''
            ];
            StartCalendarInterval = [
              {
                Hour = 2;
                Minute = 30;
              }
            ];
            StandardErrorPath = "/var/log/nix-store.log";
            StandardOutPath = "/var/log/nix-store.log";
          };

          environment.shells = [ pkgs.fish ];

          programs.fish.enable = true;
        }
      )
    ];
  };

  profile-parts.darwin = {
    EMAT-C02G44CPQ05P = {
      modules = [
        (
          { pkgs, ... }:
          {
            environment.etc."ssh/sshd_config.d/200-nix.conf".text = ''
              PasswordAuthentication no
              AllowUsers astephe9@10.3.2.* astephe9@10.20.10.* adam@10.3.2.* adam@10.20.10.*
            '';

            security.pam.enableSudoTouchIdAuth = true;
            users.users.astephe9 = {
              shell = lib.getExe pkgs.fish;
            };
          }
        )
      ];
    };

    silver =
      let
        homeModules = config.profile-parts.home-manager.silver.finalModules;
      in
      {
        modules = [
          inputs.home-manager.darwinModules.home-manager

          inputs.sandbox.darwinModules.woodpecker-agents
          (
            { config, pkgs, ... }:
            {

              home-manager.users.adam = {
                imports = homeModules ++ [ { dotfiles.nixosManaged = true; } ];
              };

              home-manager.extraSpecialArgs = {
                inherit inputs;
                npins = import ../npins;
              };

              services.woodpecker-agents.agents.default = {
                enable = true;

                environment = {
                  WOODPECKER_BACKEND = "local";
                  WOODPECKER_FILTER_LABELS = "type=local,system=${pkgs.system}";
                  WOODPECKER_MAX_WORKFLOWS = "1";
                  WOODPECKER_SERVER = "woodpecker-grpc.junco.dev:9000";
                  WOODPECKER_GRPC_SECURE = "false";
                };
                environmentFile = [ "/etc/woodpecker-agent.env" ];

                path = [
                  config.nix.package
                  pkgs.woodpecker-plugin-git
                  pkgs.bash
                  pkgs.coreutils
                  pkgs.git
                  pkgs.git-lfs
                  pkgs.gnutar
                  pkgs.gzip
                ];
              };

              users.users.adam = {
                home = "/Users/adam";
                uid = 501;
              };
            }
          )
        ];
      };
  };
}
