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

    gc = {
      automatic = true;
      interval = [
        {
          Hour = 7;
          Minute = 0;
        }
      ];
      options = "--delete-older-than 14d";
    };

    settings = {
      auto-optimise-store = false;
      accept-flake-config = false;
      builders-use-substitutes = true;
      experimental-features = [
        "ca-derivations"
        "dynamic-derivations"
        "flakes"
        "nix-command"
        "pipe-operators"
        "recursive-nix"
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

  # add a log to the nix-darwin gc'er
  launchd.daemons."nix-gc".serviceConfig = {
    StandardErrorPath = "/var/log/nix-gc.log";
    StandardOutPath = "/var/log/nix-gc.log";
  };

  # While it’s possible to set `nix.settings.auto-optimise-store`, it sometimes
  # causes problems on Darwin. So run a job periodically to optimise the store:
  # https://github.com/NixOS/nix/issues/7273
  launchd.daemons."nix-store-optimise".serviceConfig = {
    Program =
      pkgs.writeShellApplication {
        name = "nix-store-optimise";

        runtimeInputs = [
          config.nix.package
        ];

        text = ''
          /bin/wait4path /nix/store && exec nix store optimise
        '';
      }
      |> lib.getExe;

    StartCalendarInterval = [
      {
        Hour = 2;
        Minute = 30;
      }
    ];

    StandardErrorPath = "/var/log/nix-store.log";
    StandardOutPath = "/var/log/nix-store.log";
  };

  # logrotate our logs
  system.newsyslog = {
    enable = true;

    files.nix = [
      {
        logfilename = "/var/log/nix-gc.log";
        owner = "root";
        group = "wheel";
        count = 2;
        size = 15 * 1024 |> toString;
        flags = [
          "N"
          "Z"
        ];
      }
      {
        logfilename = "/var/log/nix-store.log";
        owner = "root";
        group = "wheel";
        count = 2;
        size = "1024";
        flags = [
          "N"
          "Z"
        ];
      }
    ];
  };

}
