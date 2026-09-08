{
  inputs,
  self,
  withSystem,
  ...
}:
{
  flake.darwinConfigurations.willow = withSystem "aarch64-darwin" (
    { system, ... }:
    inputs.nix-darwin.lib.darwinSystem {
      pkgs = import inputs.nixpkgs-unstable {
        inherit system;
      };

      specialArgs = {
        inherit inputs;
        flake = self;
        npins = import ../npins;
      };

      modules = [
        ./modules/builders.nix
        ./modules/junco-traefik.nix
        ./modules/nix.nix
        ./modules/pf.nix
        ./modules/system.nix
        ./modules/user.nix

        (inputs.nix-darwin.outPath + "/modules/nix/nix-darwin.nix") # install darwin-rebuild
        inputs.hjem.darwinModules.default
        inputs.nbac.darwinModules.default
      ];
    }
  );
}
