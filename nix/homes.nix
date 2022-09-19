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
          (pkgs.lib.optionals pkgs.stdenv.isDarwin ./darwin.nix)
          inputs.doom-emacs.hmModule
        ];

        extraSpecialArgs = {
        };
      });
in {
  flake.homeConfigurations = {
    adam-aarch64-darwin = homeConfig {
      username = "adam";
      home = "/Users/adam";
      homeSystem = "aarch64-darwin";
    };
    astephe9-aarch64-darwin = homeConfig {
      username = "astephe9";
      home = "/Users/astephe9";
      homeSystem = "aarch64-darwin";
    };
    adam-x86_64-linux = homeConfig {
      username = "adam";
      home = "/home/adam";
      homeSystem = "x86_64-linux";
    };
    adam-aarch64-linux = homeConfig {
      username = "adam";
      home = "/home/adam";
      homeSystem = "aarch64-linux";
    };
  };
}
