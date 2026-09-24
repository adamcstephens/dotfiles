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
              # ./output-power.patch
              ./add-river.patch
              ./river-classic-output.patch
            ];

            doCheck = false;
          });
    };
  };

  config = {
    xdg.config.files = {
      noctalia.source = config.dotfiles.source "apps/noctalia";
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

      # since we launch other applications, let's leverage the systemd environment completely
      enableDefaultPath = false;

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
      };
    };
  };
}
