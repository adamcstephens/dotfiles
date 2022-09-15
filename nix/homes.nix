{
  inputs,
  withSystem,
  ...
}: let
  homeConfig = {
    username,
    home,
    homeSystem,
  }:
    withSystem homeSystem ({
      pkgs,
      system,
      ...
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          (_: {
            home.username = username;
            home.homeDirectory = home;
          })
          ./home.nix
        ];

        extraSpecialArgs = {
          nil = inputs.nil.packages.${system};
        };
      });
in {
  flake.homeConfigurations = {
    astephe9-arm64-Darwin = homeConfig {
      username = "astephe9";
      home = "/Users/astephe9";
      homeSystem = "aarch64-darwin";
    };
    adam-x86_64-Linux = homeConfig {
      username = "adam";
      home = "/home/adam";
      homeSystem = "x86_64-linux";
    };
    adam-aarch64-Linux = homeConfig {
      username = "adam";
      home = "/home/adam";
      homeSystem = "aarch64-linux";
    };
  };
}
