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
        # hooks.post-launch = {
        #   "claude-auth"
        # };
      };

      environment.systemPackages = [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode
      ];

      home-manager = {
        users.adam = {
          imports = self.homeModules.core-dev ++ [
            {
              dotfiles.nixosManaged = true;
              home.packages = [
                inputs.vein.packages.${pkgs.stdenv.hostPlatform.system}.vein
              ];
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
        substituters = [ "https://cache.junco.dev/v4" ];
        trusted-public-keys = [ "v4:6cq9xeMAepF20fTnv+ChvLkPLzBtCD9NRUaKrarK+nU=" ];
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
