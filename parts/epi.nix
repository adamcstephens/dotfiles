{
  inputs,
  self,
  ...
}:
let
  common =
    {
      config,
      lib,
      ...
    }:
    {
      epi = {
        enable = true;
        extraStorePaths = [
          config.home-manager.users.adam.home.activationPackage
        ];
      };

      home-manager = {
        users.adam = {
          imports = [
            {
              dotfiles.nixosManaged = true;
              nix.package = lib.mkOverride 30 config.nix.package;
              nix.registry.nixpkgs.flake = lib.mkForce inputs.nixpkgs-unstable;
            }
          ];
        };

        extraSpecialArgs = {
          inherit inputs;
          npins = import ../npins;
          flake = self;
        };
      };

      nix.settings = {
        extra-experimental-features =
          lib.optionals (
            config.nix.package.pname == "nix" && lib.versionAtLeast config.nix.package.version "2.24"
          ) [ "pipe-operators" ]
          ++ lib.optionals (
            config.nix.package.pname == "lix" && lib.versionAtLeast config.nix.package.version "2.91"
          ) [ "pipe-operator" ];
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
    agents-aarch64 = inputs.nixpkgs-unstable.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        inputs.epi.nixosModules.epi
        inputs.home-manager-unstable.nixosModules.home-manager
        common
        {
          home-manager.users.adam.imports = self.homeModules.agents ++ [
            { home.file.".dotfiles".source = "${self}"; }
          ];
        }
      ];
    };

    agents = inputs.nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.epi.nixosModules.epi
        inputs.home-manager-unstable.nixosModules.home-manager
        common
        {
          home-manager.users.adam.imports = self.homeModules.agents-aarch64 ++ [
            { home.file.".dotfiles".source = "${self}"; }
          ];
        }
      ];
    };

    dotfiles = inputs.nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.epi.nixosModules.epi
        inputs.home-manager-unstable.nixosModules.home-manager
        common
        {
          home-manager.users.adam.imports = self.homeModules.agents ++ [ ];
        }
      ];
    };
  };

  flake.sowerJobs.x86_64-linux = {
    "epi/agents/disk" = self.nixosConfigurations.agents.config.system.build.image;
    "epi/agents/initrd" = self.nixosConfigurations.agents.config.system.build.initialRamdisk;
    "epi/agents/kernel" = self.nixosConfigurations.agents.config.system.build.kernel;

    "epi/dotfiles/disk" = self.nixosConfigurations.dotfiles.config.system.build.image;
    "epi/dotfiles/initrd" = self.nixosConfigurations.dotfiles.config.system.build.initialRamdisk;
    "epi/dotfiles/kernel" = self.nixosConfigurations.dotfiles.config.system.build.kernel;
  };
}
