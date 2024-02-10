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

              substituters = [ "https://attic.junco.dev/default?priority=41" ];
              trusted-public-keys = [ "default:sMQjcuRXHFczHLa2lqmmNSI7TuFic8hnfJAs59fVpAg=" ];
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

          inputs.sandbox.darwinModules.forgejo-actions-runner
          (
            { config, pkgs, ... }:
            {
              users.users.adam = {
                home = "/Users/adam";
                uid = 501;
              };

              home-manager.users.adam = {
                imports = homeModules;
              };

              home-manager.extraSpecialArgs = {
                inherit inputs;
                npins = import ../npins;
              };

              services.forgejo-actions-runner.instances.default = {
                labels = [
                  "stop/${pkgs.system}:host"
                  "sower/seed-ci/${pkgs.system}:host"
                  "local/${pkgs.system}:host"
                ];
                name = config.networking.hostName;
                tokenFile = "/etc/forgejo-token.env";
                url = "https://git.junco.dev";
                settings.runner.envs = {
                  ATTIC_URL = "https://attic.junco.dev";
                  ATTIC_CACHE = "default";
                };
                hostPackages = [
                  config.nix.package

                  inputs.attic.packages.${pkgs.system}.attic
                  inputs.sower.packages.${pkgs.system}.seed-ci

                  pkgs.bash
                  pkgs.cachix
                  pkgs.coreutils
                  pkgs.curl
                  pkgs.gawk
                  pkgs.gitMinimal
                  pkgs.gnused
                  pkgs.jq
                  pkgs.nodejs
                  pkgs.nushell
                  pkgs.wget
                ];
              };
            }
          )
        ];
      };
  };
}
