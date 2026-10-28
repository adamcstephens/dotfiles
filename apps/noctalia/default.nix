{
  config,
  dotlib,
  inputs,
  lib,
  pkgs,
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
              ./logind-idle-hint.patch
              ./inhibit-sync.patch
            ];

            doCheck = false;
          });
    };
  };

  config = {
    xdg.configFile =
      lib.mapAttrs' (
        name: _:
        lib.nameValuePair "noctalia/${name}" {
          source = dotlib.source "apps/noctalia/${name}";
        }
      ) (builtins.readDir ./.)
      // lib.optionalAttrs (builtins.pathExists (./profiles + "/${config.dotfiles.profile}.toml")) {
        "noctalia/profile.toml".text = # toml
          ''
            [include]
            files = ["profiles/${config.dotfiles.profile}.toml"]
          '';
      };

    home.packages = [
      cfg.package
    ];

    systemd.user.services.noctalia = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      Unit.PartOf = [ "graphical-session.target" ];
      Unit.After = [ "graphical-session.target" ];
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
      };
    };
  };
}
