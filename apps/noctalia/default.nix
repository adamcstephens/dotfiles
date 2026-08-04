{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.config.files."noctalia".source =
    if config.dotfiles.nixosManaged then ./. else "${config.directory}/.dotfiles/apps/noctalia";

  packages = [
    pkgs.noctalia
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
      ExecStart = lib.getExe pkgs.noctalia;
      Restart = "on-failure";
    };
  };
}
