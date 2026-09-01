{
  inputs,
  self,
  ...
}:
let
  common =
    { config, ... }:
    {
      imports = [
        inputs.epi.nixosModules.epi
        inputs.hjem.nixosModules.hjem
      ];

      epi = {
        enable = true;
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
          "https://cache-v5.junco.dev"
        ];
        trusted-public-keys = [
          "cache-v6:tXeE+WhO6k2OoUoNSzmQVIckjXtl14mtO+z0ZwAIork="
        ];
      };

      programs.fish.enable = true;

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
