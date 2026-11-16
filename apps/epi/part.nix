{
  inputs,
  self,
  ...
}:
let
  common =
    {
      config,
      ...
    }:
    {
      imports = [
        inputs.epi.nixosModules.epi
      ]
      ++ self.homeManagerProfiles.dev;

      epi.enable = true;

      home-manager.users.adam.onenix.enable = false;

      networking.nftables.enable = true;

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
  };

  flake.sowerJobs = {
    aarch64-linux = {
      "epi/agents/disk" = self.nixosConfigurations.agents-aarch64.config.system.build.image;
    };
    x86_64-linux = {
      "epi/agents/diskQcow2" = self.nixosConfigurations.agents.config.system.build.epiDiskQcow2;
      "epi/agents/initrd" = self.nixosConfigurations.agents.config.system.build.initialRamdisk;
      "epi/agents/kernel" = self.nixosConfigurations.agents.config.system.build.kernel;
    };
  };
}
