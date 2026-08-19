{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.dotfiles.macos.builder;
in
{
  options = {
    dotfiles.macos.builder = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "linux-builder"
          "nbac"
        ]
      );
      description = "which aarch64-linux builder to enable";
      default = null;
    };
  };

  config = lib.mkMerge [
    {
      dotfiles.macos.builder = "nbac";
    }
    {
      nix = {
        distributedBuilds = true;
        buildMachines = [
          {
            protocol = "ssh-ng";
            hostName = "leaf.h.junco.dev";
            maxJobs = 8;
            sshUser = "builder";
            supportedFeatures = [
              "big-parallel"
              "kvm"
              "nixos-test"
              "uid-range"
            ];
            systems = [
              "x86_64-linux"
            ];
            sshKey = "/var/root/.ssh/id_ed25519";
          }
        ];
        settings.trusted-users = [ "remote-builder" ];

        linux-builder = lib.mkIf (cfg == "linux-builder") {
          enable = true;
          # use stable release
          # https://github.com/NixOS/nixpkgs/issues/528299
          package = inputs.nixpkgs.legacyPackages.aarch64-darwin.darwin.linux-builder;

          maxJobs = 4;

          supportedFeatures = [
            "apple-virt"
            "benchmark"
            "big-parallel"
            "kvm"
            "nixos-test"
          ];

          config = {
            virtualisation = {
              cores = 8;
              darwin-builder = {
                memorySize = 16 * 1024;
                diskSize = 100 * 1024;
              };
            };
          };
        };
      };

      environment.etc."ssh/ssh_config.d/100-leaf.conf" = {
        text = ''
          Host leaf.h.junco.dev
              ControlMaster auto
              ControlPath ~/.ssh/%r@%h-%p
              ControlPersist 600
        '';
      };

      services.nbac = lib.mkIf (cfg == "nbac") {
        enable = true;
        machine = {
          cpus = 16;
          memory = "12G";
        };
        stateDir = "/Users/adam/.local/state/nbac";
        supportedFeatures = [
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
        virtualization.enable = true;
        home.enable = true;
        image.packages = [
          "nix-output-monitor"
        ];
      };

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
}
