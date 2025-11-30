{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.sower;
in
{
  imports = [ inputs.sower.homeModules.sower ];

  options.apps.sower = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = !config.dotfiles.nixosManaged && pkgs.stdenv.isLinux;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.client
    ];

    services.sower.client = {
      enable = true;
      package = inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.client;

      config = {
        # get the token from the host-managed location
        api-token-file = "/run/agenix/sower-api-token";
        endpoint = "https://sower.junco.dev";
        seed.name = config.dotfiles.profile;
      };
    };
  };
}
