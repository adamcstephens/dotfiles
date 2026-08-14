{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.sower;
in
{
  imports = [ inputs.sower.homeModules.sower ];

  options.dotfiles.apps.sower = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      # default = !config.dotfiles.nixosManaged && pkgs.stdenv.hostPlatform.isLinux;
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [
      inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.sower
    ];

    services.sower.garden = {
      enable = true;
      package = inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.garden;
      activatorPackage = inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.activator;

      settings = {
        access_token_file = "/run/agenix/sower-api-token";
        # get the token from the host-managed location
        endpoint = "https://sower.junco.dev";

        subscriptions = {
          ${config.dotfiles.profile} = {
            seed_name = config.dotfiles.profile;
            seed_type = "home-manager";

            # https://hexdocs.pm/crontab/cron_notation.html
            schedule = lib.mkDefault "@hourly";

            rules = [ "git_branch=main" ];

            policy = {
              manual = {
                actions = [ "activate" ];
                triggers = [ "manual" ];
              };

              maintenance = {
                actions = lib.mkDefault [
                  "stage"
                  "activate"
                ];
                triggers = [
                  "scheduled"
                  "poll_on_connect"
                ];
              };
            };
          };
        };
      };
    };

    systemd.user.services.sower-garden.Service.Environment = [
      "RELEASE_NODE=deck-adam"
    ];
  };
}
