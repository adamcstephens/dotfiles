{
  config,
  inputs,
  self,
  ...
}:
{
  imports = [ inputs.profile-parts.flakeModules.darwin ];

  profile-parts.default.darwin = {
    inherit (inputs) nix-darwin;
    nixpkgs = inputs.nixpkgs-unstable;
    exposePackages = true;
  };

  profile-parts.global.darwin = {
    modules = [
      (inputs.nix-darwin.outPath + "/modules/nix/nix-darwin.nix") # install darwin-rebuild
      (
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          fonts.packages = [
            pkgs.noto-fonts
            pkgs.font-awesome
            pkgs.ibm-plex
            pkgs.jetbrains-mono
            pkgs.material-icons
            pkgs.material-design-icons
            pkgs.nerd-fonts.symbols-only
          ];

          nix = {
            buildMachines = [
              {
                protocol = "ssh";
                hostName = "nixos2.local";
                maxJobs = 4;
                sshUser = "root";
                supportedFeatures = [
                  "big-parallel"
                  "kvm"
                  "nixos-test"
                ];
                systems = [
                  "aarch64-linux"
                ];
              }
              {
                protocol = "ssh";
                hostName = "branch.tail68e370.ts.net";
                maxJobs = 4;
                sshUser = "adam";
                supportedFeatures = [
                  "big-parallel"
                  "kvm"
                  "nixos-test"
                ];
                systems = [
                  "x86_64-linux"
                ];
              }
            ];

            channel.enable = false;

            distributedBuilds = true;

            enable = true;

            gc = {
              automatic = true;
              interval = {
                Hour = 3;
                Minute = 15;
              };
              options = "--delete-older-than 30d";
            };

            package = pkgs.nixVersions.nix_2_31;

            settings = {
              auto-optimise-store = false;
              accept-flake-config = false;
              experimental-features = [
                "nix-command"
                "flakes"
              ]
              ++ lib.optionals (
                config.nix.package.pname == "nix" && lib.versionAtLeast config.nix.package.version "2.24"
              ) [ "pipe-operators" ]
              ++ lib.optionals (
                config.nix.package.pname == "lix" && lib.versionAtLeast config.nix.package.version "2.91"
              ) [ "pipe-operator" ];

              download-buffer-size = lib.mkDefault (256 * 1024 * 1024);
              http-connections = lib.mkDefault 128;
              max-substitution-jobs = lib.mkDefault 128;

              min-free = "50G";
              max-free = "100G";

              trusted-users = [
                "root"
                "@admin"
              ];

              substituters = [ "https://cache.junco.dev/v4?priority=41" ];
              trusted-public-keys = [ "v4:6cq9xeMAepF20fTnv+ChvLkPLzBtCD9NRUaKrarK+nU=" ];
              extra-platforms = "x86_64-darwin";
            };
          };

          system.activationScripts.extraActivation.text = ''
            echo "removing nix from default profile"

            if nix profile list --json --profile /nix/var/nix/profiles/default | ${lib.getExe pkgs.gojq} --raw-output --exit-status .elements.nix; then
              nix profile remove nix --profile /nix/var/nix/profiles/default
            fi
          '';

          system.defaults = {
            NSGlobalDomain = {
              AppleShowScrollBars = "Always";
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
                /bin/wait4path ${config.nix.package}/bin/nix && \
                  exec ${config.nix.package}/bin/nix store optimise
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

          environment.shells = [ config.programs.fish.package ];

          programs.fish = {
            enable = true;
            package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.fish;
          };
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
            { ... }:
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

              nixpkgs.overlays = [
                self.overlays.default
                self.overlays.dotfiles
                self.overlays.upstreams
              ];

              security.pam.services.sudo_local = {
                reattach = true;
                touchIdAuth = true;
              };

              system.primaryUser = "adam";
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
