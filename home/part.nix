{
  inputs,
  self,
  withSystem,
  ...
}:
let
  flake = self;

  user.home = {
    username = "adam";
    homeDirectory = "/home/adam";
  };

  extraSpecialArgs = {
    inherit flake inputs;

    npins = import ../npins;
  };

  nixosCommon = [
    inputs.home-manager.nixosModules.home-manager
    ./migrate-nixos.nix
    ({ pkgs, ... }: {
      home-manager = {
        extraSpecialArgs = extraSpecialArgs // {
          pkgs = withSystem pkgs.stdenv.hostPlatform.system ({ pkgs, ... }: pkgs);
          lib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" inputs.nixpkgs.lib;
        };
        useGlobalPkgs = false;
        useUserPackages = true;
        users.adam = {
          imports = [ ./core.nix ];
          dotfiles.nixosManaged = true;
          home.file.".dotfiles".source = "${self}";
        };
      };
    })
  ];

  standaloneModules = [
    user
    ./core.nix
    ./dev.nix
    ./linux-gui.nix
  ];
in
{
  flake.homeManagerProfiles = {
    core = nixosCommon;

    dev = nixosCommon ++ [
      {
        home-manager.users.adam.imports = [
          ./dev.nix
          ../apps/paseo
          ../apps/rex
        ];
      }
    ];
  };

  flake.homeConfigurations = withSystem "x86_64-linux" (
    { pkgs, ... }:
    {
      agents = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = extraSpecialArgs // {
          profile = "agents";
        };

        modules = standaloneModules ++ [ ../apps/paseo ];
      };

      deck = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = extraSpecialArgs // {
          profile = "deck";
        };

        modules = standaloneModules ++ [
          inputs.epi.homeManagerModules.epi
          (
            { config, lib, ... }:
            let

              epi-agent =
                {
                  project,
                  project_dir ? "${config.home.homeDirectory}/projects/${project}",
                  settings ? { },
                }:
                {
                  enable = true;
                  settings = lib.mkMerge [
                    {
                      # target = flake.nixosConfigurations.agents.config.system.build.epi;
                      target = "git+https://tangled.org/adam.robins.wtf/dotfiles?ref=main#agents";
                      inherit project_dir;
                      mounts = [
                        "~/.local/state/paseo/${project}:~/.local/state/paseo"
                      ];
                    }
                    settings
                  ];
                };

              paseoDirs =
                config.services.epi.instances
                |> (lib.foldlAttrs (
                  acc: n: v:
                  acc ++ v.settings.mounts
                ) [ ])
                |> lib.map (m: lib.splitString ":" m |> lib.head)
                |> lib.filter (m: lib.strings.hasInfix "paseo" m)
                |> lib.map (m: lib.replaceString "~/" "${config.home.homeDirectory}/" m)
                |> lib.unique;
            in
            {
              home.activation.paseoDirectories = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                run mkdir --parents -- ${lib.escapeShellArgs paseoDirs}
              '';

              services.epi = {
                package = inputs.epi.packages.x86_64-linux.epi;
                instances = {
                  epi = epi-agent { project = "epi"; };
                  git-sync = epi-agent { project = "git-sync"; };
                  hjem = epi-agent {
                    project = "hjem";
                    project_dir = "${config.home.homeDirectory}/git/hjem";
                  };
                  noctalia = epi-agent {
                    project = "noctalia";
                    project_dir = "${config.home.homeDirectory}/git/noctalia";
                  };
                  sower = epi-agent {
                    project = "sower";
                    settings = {
                      cpus = 8;
                      memory = 16384;
                      disk_size = "80G";
                      ports = [ "7150:7150" ];
                    };
                  };
                  tracker-deck = epi-agent { project = "tracker"; };
                };
              };
            }
          )
        ];
      };

      funk = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = extraSpecialArgs // {
          profile = "funk";
        };

        modules = standaloneModules ++ [
          {
            dotfiles.apps.ssh.tpm.enable = true;
          }
        ];
      };
    }
  );
}
