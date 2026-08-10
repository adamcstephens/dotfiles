{
  config,
  lib,
  pkgs,
  profile,
  ...
}:
let
  package = pkgs.noctalia.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./sorted-workspaces.patch
      ./add-pinnacle.patch
      ./logind-idle-hint.patch
    ];
  });
in
{
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
    package
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
      ExecStart = lib.getExe package;
      Restart = "on-failure";
    };
  };
}
