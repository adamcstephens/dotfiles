{
  pkgs,
  config,
  lib,
  ...
}: let
  systemctlBin = "/run/current-system/sw/bin/systemctl";
  locker = "${pkgs.procps}/bin/pgrep gtklock || ${pkgs.util-linux}/bin/setsid --fork ${pkgs.gtklock}/bin/gtklock";
  swayidle = pkgs.swayidle.overrideAttrs (old: rec {
    version = "1.8.0";

    postPatch = null;

    src = pkgs.fetchFromGitHub {
      owner = "swaywm";
      repo = "swayidle";
      rev = version;
      sha256 = "sha256-/U6Y9H5ZqIJph3TZVcwr9+Qfd6NZNYComXuC1D9uGHg=";
    };
  });
in {
  services.swayidle = {
    enable = true;
    package = swayidle;
    systemdTarget = "graphical-session.target";
    events = [
      {
        event = "before-sleep";
        command = "${locker}";
      }
    ];
    timeouts =
      [
        {
          timeout = 120;
          command = "${locker}";
        }
      ]
      ++ (lib.optionals (!config.dotfiles.isVM) [
        {
          timeout = 360;
          command = "${systemctlBin} suspend";
        }
      ]);
  };
}
