{
  config,
  inputs,
  lib,
  pkgs,
  profile,
  ...
}:
let
  cfg = config.dotfiles.apps.noctalia;
in
{
  options = {
    dotfiles.apps.noctalia.package = lib.mkOption {
      type = lib.types.package;
      default =
        inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.noctalia.overrideAttrs
          (old: {
            patches = (old.patches or [ ]) ++ [
              ./sorted-workspaces.patch
              ./add-pinnacle.patch
              ./logind-idle-hint.patch
              ./inhibit-sync.patch
              (pkgs.fetchpatch2 {
                url = "https://github.com/noctalia-dev/noctalia/commit/4dcb8254eeed28edd69ec2d3bec90715b19ba0fd.patch?full_index=1";
                hash = "sha256-zDbCgYbkedH7JCSR/ajXOaB3dlS6UkZb9rNwIF+s5yE=";
              })
            ];
          });
    };
  };

  config = {
    xdg.config.files = {
      noctalia.source =
        if config.dotfiles.nixosManaged then ./. else "${config.directory}/.dotfiles/apps/noctalia";
    }
    // lib.optionalAttrs (builtins.pathExists (./profiles + "/${profile}.toml")) {
      "noctalia/profile.toml".text = # toml
        ''
          [include]
          files = ["profiles/${profile}.toml"]
        '';
    };

    packages = [
      cfg.package
    ];

    systemd.services.noctalia = {
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      enableDefaultPath = false;

      environment = {
        XDG_DATA_DIRS = lib.concatStringsSep ":" [
          "${config.directory}/.local/state/hjem/standalone/current-profile/share"
          "${config.directory}/.local/state/nix/profile/share"
          "${config.directory}/.nix-profile/share"
          "${config.directory}/.local/share/flatpak/exports/share"
          "/run/current-system/sw/share"
        ];
      };

      path = [
        "${config.directory}/.local/state/hjem/standalone/current-profile"
        "/run/current-system/sw"
      ];

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
      };
    };
  };
}
