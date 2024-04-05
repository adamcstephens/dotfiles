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
      default = !config.dotfiles.nixosManaged;
    };
  };

  config = lib.mkIf cfg.enable {
    services.sower.client = {
      enable = true;
      package = inputs.sower.packages.${pkgs.system}.cli;

      config = {
        url = "https://sower.junco.dev";
      };
    };
    #
  };
}
