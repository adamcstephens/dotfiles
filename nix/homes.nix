{
  inputs,
  withSystem,
  ...
}: let
  homeConfig = {
    username ? "adam",
    homeSystem,
  }:
    withSystem homeSystem ({
      pkgs,
      system,
      ...
    }: let
      homeDir =
        if pkgs.stdenv.isDarwin
        then "/Users/${username}"
        else "/home/${username}";
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules =
          [
            ./home.nix
            inputs.doom-emacs.hmModule
            {
              home.username = username;
              home.homeDirectory = homeDir;
            }
          ]
          ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [./darwin.nix])
          ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [./linux.nix]);

        extraSpecialArgs = {
        };
      });
in {
  flake.homeConfigurations = {
    EMAT-C02G44CPQ05P = homeConfig {
      username = "astephe9";
      homeSystem = "aarch64-darwin";
    };
    aarch64-darwin = homeConfig {
      homeSystem = "aarch64-darwin";
    };
    x86_64-linux = homeConfig {
      homeSystem = "x86_64-linux";
    };
    aarch64-linux = homeConfig {
      homeSystem = "aarch64-linux";
    };
  };
}
