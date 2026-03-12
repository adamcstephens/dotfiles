{ inputs, self, ... }:
let
  common =

    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      epi = {
        enable = true;
        extraStorePaths = [
          config.home-manager.users.adam.home.activationPackage
        ];
      };

      environment.systemPackages = [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.openspec
      ];

      home-manager = {
        users.adam = {
          imports = self.homeModules.core-dev ++ [
            {
              nix.registry.nixpkgs.flake = lib.mkForce inputs.nixpkgs-unstable;
              dotfiles.nixosManaged = true;
              nix.package = lib.mkOverride 30 config.nix.package;
            }
          ];
        };

        extraSpecialArgs = {
          inherit inputs;
          npins = import ../npins;
          flake = self;
        };
      };

      programs.fish.enable = true;

      users.users.adam = {
        isNormalUser = true;
        group = "adam";
        extraGroups = [ "wheel" ];
        shell = config.programs.fish.package;
      };
      users.groups.adam = { };
    };
in
{
  flake.nixosConfigurations = {
    agents = inputs.nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.epi.nixosModules.epi
        inputs.home-manager-unstable.nixosModules.home-manager
        common
        {
          home-manager.users.adam.imports = [
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
      ];
    };
  };
}
