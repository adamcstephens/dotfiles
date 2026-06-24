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
            channel.enable = false;

            enable = true;

            settings = {
              auto-optimise-store = false;
              accept-flake-config = false;
              builders-use-substitutes = true;
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

              download-buffer-size = lib.mkIf (config.nix.package.pname == "nix") (
                lib.mkDefault (256 * 1024 * 1024)
              );
              http-connections = lib.mkDefault 128;
              max-substitution-jobs = lib.mkDefault 128;

              trusted-users = [
                "root"
                "@admin"
              ];

              substituters = [
                "https://cache-v5.junco.dev?priority=41"
              ];
              trusted-public-keys = [
                "cache-v6:tXeE+WhO6k2OoUoNSzmQVIckjXtl14mtO+z0ZwAIork="
              ];
              extra-platforms = "x86_64-darwin";
            };
          };

          system.activationScripts.extraActivation.text = ''
            echo "removing nix from default profile"

            if nix profile list --json --profile /nix/var/nix/profiles/default | ${lib.getExe pkgs.gojq} --raw-output --exit-status .elements.nix; then
              nix profile remove nix --profile /nix/var/nix/profiles/default
            fi
          '';

          # disable in normal operation to avoid restarting things that break firefox profile windows in dock
          # system.defaults = {
          #   NSGlobalDomain = {
          #     AppleShowScrollBars = "Always";
          #     InitialKeyRepeat = 15;
          #     KeyRepeat = 1;
          #
          #     NSAutomaticCapitalizationEnabled = false;
          #     NSAutomaticDashSubstitutionEnabled = false;
          #     NSAutomaticPeriodSubstitutionEnabled = false;
          #     NSAutomaticQuoteSubstitutionEnabled = false;
          #     NSAutomaticSpellingCorrectionEnabled = false;
          #   };
          #   dock = {
          #     autohide = true;
          #     autohide-delay = 2.0;
          #     orientation = "left";
          #     showhidden = true;
          #     show-recents = false;
          #   };
          #   SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
          # };

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
            package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fish;
          };
        }
      )
    ];
  };

  profile-parts.darwin = {
    willow =
      let
        homeModules = config.profile-parts.home-manager.willow.finalModules;
      in
      {
        nixpkgs = inputs.nixpkgs-unstable;
        modules = [
          ../darwinModules/pf.nix
          inputs.home-manager-unstable.darwinModules.home-manager
          {
            home-manager.users.adam = {
              imports = homeModules;
            };

            home-manager.extraSpecialArgs = {
              inherit inputs;
              npins = import ../npins;
              flake = self;
            };

            networking.computerName = "willow";

            nixpkgs.overlays = [
              self.overlays.dotfiles
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
          (
            { pkgs, ... }:
            {
              nix = {
                distributedBuilds = true;
                buildMachines = [
                  {
                    protocol = "ssh";
                    hostName = "leaf.h.junco.dev";
                    maxJobs = 4;
                    sshUser = "builder";
                    supportedFeatures = [
                      "big-parallel"
                      "kvm"
                      "nixos-test"
                    ];
                    systems = [
                      "x86_64-linux"
                    ];
                    sshKey = "/var/root/.ssh/id_ed25519";
                  }
                  {
                    protocol = "ssh";
                    hostName = "nixpkgs-dev";
                    maxJobs = 8;
                    sshUser = "adam";
                    supportedFeatures = [
                      "benchmark"
                      "big-parallel"
                      "kvm"
                      "nixos-test"
                    ];
                    systems = [
                      "aarch64-linux"
                    ];
                  }
                ];

                # linux-builder = {
                #   enable = true;
                #   # use stable release
                #   # https://github.com/NixOS/nixpkgs/issues/528299
                #   package = inputs.nixpkgs.legacyPackages.aarch64-darwin.darwin.linux-builder;
                #
                #   maxJobs = 4;
                #
                #   supportedFeatures = [
                #     "apple-virt"
                #     "benchmark"
                #     "big-parallel"
                #     "kvm"
                #     "nixos-test"
                #   ];
                #
                #   config = {
                #     virtualisation = {
                #       cores = 8;
                #       darwin-builder = {
                #         memorySize = 16 * 1024;
                #         diskSize = 100 * 1024;
                #       };
                #     };
                #   };
                # };
              };

              launchd.daemons."epi-builder-ssh-config" = {
                serviceConfig = {
                  RunAtLoad = true;
                  WatchPaths = [ "/Users/adam/.local/state/epi/nixpkgs-dev/ssh_config" ];
                  StandardErrorPath = "/var/log/epi-builder-ssh-config.log";
                  StandardOutPath = "/var/log/epi-builder-ssh-config.log";
                };
                script = ''
                  epi_cfg=/Users/adam/.local/state/epi/nixpkgs-dev/ssh_config
                  if [ -f "$epi_cfg" ]; then
                    ${pkgs.coreutils}/bin/install -m 0644 -o root -g wheel \
                      "$epi_cfg" /etc/ssh/ssh_config.d/100-epi.conf
                  fi
                '';
              };
            }
          )
          #
          # junco traefik
          #
          (
            { pkgs, ... }:
            let
              tomlFormat = pkgs.formats.toml { };

              traefikDynamic = tomlFormat.generate "traefik-dynamic.toml" {
                http.routers.lmstudio = {
                  rule = "Host(`lmstudio.svc.junco.dev`) || Host(`lmstudio.junco.dev`)";
                  service = "lmstudio";
                  entryPoints = [ "websecure" ];
                  tls = {
                    certResolver = "junco";
                    domains = [
                      { main = "lmstudio.svc.junco.dev"; }
                    ];
                    options = "mtls";
                  };
                };

                http.services.lmstudio.loadBalancer.servers = [
                  { url = "http://127.0.0.1:1234"; }
                ];

                tls.options = {
                  mtls.clientAuth = {
                    caFiles = [ ./root_ca.crt ];
                    clientAuthType = "RequireAndVerifyClientCert";
                  };
                };
              };

              traefikStatic = tomlFormat.generate "traefik-static.toml" {
                entryPoints.web.address = ":18080";
                entryPoints.web.http.redirections.entryPoint = {
                  to = "websecure";
                  scheme = "https";
                };
                entryPoints.websecure.address = ":18443";

                certificatesResolvers.junco.acme = {
                  caServer = "https://cert.junco.dev/acme/acme/directory";
                  storage = "/Users/adam/.local/share/traefik/acme.json";
                  httpChallenge.entryPoint = "web";
                };

                providers.file = {
                  filename = "${traefikDynamic}";
                  watch = false;
                };
              };
            in
            {
              home-manager.users.adam = {
                home.activation.traefik-data = ''
                  mkdir -p ~/.local/share/traefik
                '';

                launchd.agents.traefik = {
                  enable = true;
                  config = {
                    ProgramArguments = [
                      "${pkgs.traefik}/bin/traefik"
                      "--configFile=${traefikStatic}"
                    ];
                    KeepAlive = true;
                    RunAtLoad = true;
                    StandardErrorPath = "/Users/adam/Library/Logs/traefik.log";
                    StandardOutPath = "/Users/adam/Library/Logs/traefik.log";
                  };
                };
              };

              # required for the pf rdr above to reach traefik
              launchd.daemons.ip-forwarding.serviceConfig = {
                ProgramArguments = [
                  "/usr/sbin/sysctl"
                  "-w"
                  "net.inet.ip.forwarding=1"
                ];
                RunAtLoad = true;
              };

              networking.applicationFirewall = {
                enable = true;
                enableStealthMode = true;
              };
              security.pf = {
                enable = true;
                rules = ''
                  # redirect 80/443 to traefik; target utun4's address, not
                  # 127.0.0.1 (macOS drops rdr-to-loopback from a real iface)
                  rdr pass on utun5 proto tcp from any to any port 80 -> (lo0) port 18080
                  rdr pass on utun5 proto tcp from any to any port 443 -> (lo0) port 18443

                  # bf traefik
                  rdr pass on lo0 inet proto tcp from any to any port 80 -> (lo0) port 8000
                  rdr pass on lo0 inet proto tcp from any to any port 443 -> (lo0) port 8443

                  pass quick on lo0 no state

                  # restrict ssh
                  block return in proto tcp from any to any port ssh
                  pass in on utun5 proto tcp from any to port ssh

                  block in proto tcp from any to any port {18080, 18443}
                '';
              };
            }
          )
          #
          # junco builder
          #
          {
            nix.settings.trusted-users = [ "remote-builder" ];

            users.knownUsers = [ "remote-builder" ];

            users.users.remote-builder = {
              createHome = true;
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFs5NiXbHfBIVf9O0VCBhmBuOSzXpSg1skLzinA5tJhu builder@builders"
              ];

              shell = "/bin/zsh";
              uid = 1000;
              home = "/Users/remote-builder";
            };
          }
        ];
      };
  };
}
