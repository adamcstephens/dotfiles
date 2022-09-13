{
  inputs,
  withSystem,
  ...
}: {
  flake.homeConfigurations = {
    astephe9 = withSystem "aarch64-darwin" ({
      pkgs,
      system,
      ...
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          (_: {
            home.username = "astephe9";
            home.homeDirectory = "/Users/astephe9";
          })
          ./home.nix
        ];

        extraSpecialArgs = {
          nil = inputs.nil.packages.aarch64-darwin;
        };
      });
    adam = withSystem "x86_64-linux" ({
      pkgs,
      system,
      ...
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          (_: {
            home.username = "adam";
            home.homeDirectory = "/home/adam";
          })
          ./home.nix
        ];

        extraSpecialArgs = {
          nil = inputs.nil.packages.x86_64-linux;
        };
      });
  };
}
