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

    serviceConfig = {
      ExecStart = lib.getExe pkgs.noctalia;
      Restart = "on-failure";
    };
  };
}
