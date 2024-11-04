{
  config,
  inputs,
  self,
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
          fonts.packages = [
            pkgs.font-awesome
            pkgs.ibm-plex
            pkgs.jetbrains-mono
            pkgs.material-icons
            pkgs.material-design-icons
            (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
          ];
          nix = {
            # buildMachines = [
            #   {
            #     hostName = "nixos1.local";
            #     maxJobs = 4;
            #     sshUser = "root";
            #     supportedFeatures = [
            #       "big-parallel"
            #       "kvm"
            #       "nixos-test"
            #     ];
            #     systems = [
            #       "aarch64-linux"
            #       "x86_64-linux"
            #     ];
            #   }
            # ];

            channel.enable = false;

            distributedBuilds = true;

            gc = {
              automatic = true;
              interval = {
                Hour = 3;
                Minute = 15;
              };
              options = "--delete-older-than 21d";
            };

            package = pkgs.nixVersions.latest;

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
    maple =
      let
        homeModules = config.profile-parts.home-manager.maple.finalModules;
      in
      {
        nixpkgs = inputs.nixpkgs-unstable;
        modules = [
          inputs.home-manager-unstable.darwinModules.home-manager

          (
            { lib, pkgs, ... }:
            {
              home-manager.users.adam = {
                imports = homeModules;
              };

              home-manager.extraSpecialArgs = {
                inherit inputs;
                npins = import ../npins;
                flake = self;
              };

              networking.computerName = "maple";

              nix.linux-builder = {
                enable = true;
                config = {
                  virtualisation = {
                    diskSize = lib.mkForce (128 * 1024);
                    memorySize = lib.mkForce (16 * 1024);
                    cores = 8;
                  };
                };
                maxJobs = 2;
                supportedFeatures = [
                  "apple-virt"
                  "benchmark"
                  "big-parallel"
                  "kvm"
                  "nixos-test"
                ];
              };

              security.pam.enableSudoTouchIdAuth = true;
              system.stateVersion = 5;
              users.users.adam = {
                home = "/Users/adam";
                shell = "/home/adam/.nix-profile/bin/fish";
              };
            }
          )
        ];
      };
  };
}
