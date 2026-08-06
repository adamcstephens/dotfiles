{
  config,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    channel.enable = false;

    enable = true;
    package = pkgs.nixVersions.latest;

    settings = {
      auto-optimise-store = false;
      accept-flake-config = false;
      builders-use-substitutes = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      download-buffer-size = lib.mkIf (config.nix.package.pname == "nix") (
        lib.mkDefault (256 * 1024 * 1024)
      );
      http-connections = lib.mkDefault 128;
      max-substitution-jobs = lib.mkDefault 128;

      trusted-users = [
        "root"
        "@admin"
      ];

      substituters = [
        "https://cache-v5.junco.dev?priority=41"
      ];
      trusted-public-keys = [
        "cache-v6:tXeE+WhO6k2OoUoNSzmQVIckjXtl14mtO+z0ZwAIork="
      ];
      extra-platforms = "x86_64-darwin";
    };
    distributedBuilds = true;

  };

  # While it’s possible to set `nix.settings.auto-optimise-store`, it sometimes
  # causes problems on Darwin. So run a job periodically to optimise the store:
  # https://github.com/NixOS/nix/issues/7273
  launchd.daemons."nix-store-optimise".serviceConfig = {
    ProgramArguments = [
      "/bin/sh"
      "-c"
      ''
        /bin/wait4path ${config.nix.package}/bin/nix && \
          exec ${config.nix.package}/bin/nix store optimise
      ''
    ];
    StartCalendarInterval = [
      {
        Hour = 2;
        Minute = 30;
      }
    ];
    StandardErrorPath = "/var/log/nix-store.log";
    StandardOutPath = "/var/log/nix-store.log";
  };
}
