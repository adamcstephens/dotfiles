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
            (_: {
              home.username = username;
              home.homeDirectory = homeDir;
            })
            ./home.nix
            inputs.doom-emacs.hmModule
          ]
          ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [./darwin.nix])
          ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [./linux.nix]);

        extraSpecialArgs = {
        };
      });
in {
  flake.homeConfigurations = {
    adam-aarch64-darwin = homeConfig {
      homeSystem = "aarch64-darwin";
    };
    astephe9-aarch64-darwin = homeConfig {
      username = "astephe9";
      homeSystem = "aarch64-darwin";
    };
    adam-x86_64-linux = homeConfig {
      homeSystem = "x86_64-linux";
    };
    adam-aarch64-linux = homeConfig {
      homeSystem = "aarch64-linux";
    };
  };
}
