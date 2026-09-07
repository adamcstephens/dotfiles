{
  inputs,
  self,
  ...
}:
let
  npins = import ../../npins;

  common =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.epi.nixosModules.epi
        inputs.hjem.nixosModules.hjem
        # "${npins.paseo}/nix/module.nix"
      ];

      epi = {
        enable = true;

        hooks.post-launch."10-netbird.sh" =
          pkgs.writeScriptBin "10-netbird" ''
            #!/usr/bin/env bash

            "$EPI_BIN" cp /run/agenix/epi-netbird-env "$EPI_INSTANCE:/tmp/netbird.env"
            "$EPI_BIN" cp /run/agenix/epi-netbird-setup-key "$EPI_INSTANCE:/tmp/setup-key"

            "$EPI_BIN" exec "$EPI_INSTANCE" -- sudo mv /tmp/netbird.env /var/lib/netbird-vrob0/env
            "$EPI_BIN" exec "$EPI_INSTANCE" -- sudo mv /tmp/setup-key /var/lib/netbird-vrob0/setup-key
            "$EPI_BIN" exec "$EPI_INSTANCE" -- sudo chown root:root /var/lib/netbird-vrob0/env /var/lib/netbird-vrob0/setup-key
            "$EPI_BIN" exec "$EPI_INSTANCE" -- sudo chmod 0444 /var/lib/netbird-vrob0/env /var/lib/netbird-vrob0/setup-key
            "$EPI_BIN" exec "$EPI_INSTANCE" -- sudo systemctl restart --no-block netbird-vrob0-login
          ''
          |> lib.getExe;
      };

      hjem = {
        clobberByDefault = true;

        specialArgs = {
          inherit inputs;

          flake = self;
          npins = import ../../npins;
        };

        extraModules = [
          ../../hjem/core.nix
          ../../hjem/dev.nix

          ../paseo
        ];

        users.adam = {
          directory = "/home/adam";
          user = "adam";
          files.".dotfiles".source = "${self}";
        };
      };

      nix.settings = {
        extra-experimental-features = [ "pipe-operators" ];
        substituters = [
          "https://cache-v6.junco.dev"
        ];
        trusted-public-keys = [
          "cache-v6:tXeE+WhO6k2OoUoNSzmQVIckjXtl14mtO+z0ZwAIork="
        ];
      };

      programs.fish.enable = true;

      services.netbird = {
        clients.vrob0 = {
          port = 61820;
          login = {
            enable = true;
            setupKeyFile = "/var/lib/netbird-vrob0/setup-key";
          };
        };
      };

      systemd.services.netbird-vrob0-login = {
        # NB_MANAGEMENT_URL=https://...:443
        # NB_ENABLE_ROSENPASS=true
        # NB_PRESHARED_KEY=...
        serviceConfig.EnvironmentFile = [
          "/var/lib/netbird-vrob0/env"
        ];
      };

      # services.paseo = {
      #   enable = true;
      #   package = (pkgs.callPackage "${npins.paseo}/nix/package.nix" { }).override {
      #     npmDepsHash = "sha256-0hOGev0HglOQmofzPQMfiWh1opg6cpiEgsfK22AKcGk=";
      #   };
      #   hostnames = true; # allow any
      #   relay.enable = false;
      #   user = "adam";
      #   # dataDir = "/home/adam/.config/paseo";
      # };

      users.users.adam = {
        isNormalUser = true;
        group = "users";
        extraGroups = [ "wheel" ];
        shell = config.programs.fish.package;
        linger = true;
      };
    };
in
{
  flake.nixosConfigurations = {
    agents-aarch64 = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ common ];
    };

    agents = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ common ];
    };

    dotfiles = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ common ];
    };
  };

  flake.sowerJobs = {
    aarch64-linux = {
      "epi/agents/disk" = self.nixosConfigurations.agents-aarch64.config.system.build.image;
    };
    x86_64-linux = {
      "epi/agents/disk" = self.nixosConfigurations.agents.config.system.build.image;
      "epi/agents/diskQcow2" = self.nixosConfigurations.agents.config.system.build.epiDiskQcow2;
      "epi/agents/initrd" = self.nixosConfigurations.agents.config.system.build.initialRamdisk;
      "epi/agents/kernel" = self.nixosConfigurations.agents.config.system.build.kernel;

      "epi/dotfiles/disk" = self.nixosConfigurations.dotfiles.config.system.build.image;
      "epi/dotfiles/initrd" = self.nixosConfigurations.dotfiles.config.system.build.initialRamdisk;
      "epi/dotfiles/kernel" = self.nixosConfigurations.dotfiles.config.system.build.kernel;
    };
  };
}
