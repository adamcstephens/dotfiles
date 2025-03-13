{ lib, pkgs, ... }:
{
  services.grobi = {
    enable = true;
    rules = [
      {
        name = "docked";
        outputs_connected = [
          "DP-6"
          "eDP-1"
        ];
        configure_single = "DP-6";
        primary = true;
        atomic = true;
        execute_after = [
          "/run/current-system/sw/bin/systemd-run --user --on-active=5s ${lib.getExe pkgs.xorg.xset} r rate 160 80"
        ];
      }
      {
        name = "docked";
        outputs_connected = [
          "DP-5"
          "eDP-1"
        ];
        configure_single = "DP-5";
        primary = true;
        atomic = true;
        execute_after = [
          "/run/current-system/sw/bin/systemd-run --user --on-active=5s ${lib.getExe pkgs.xorg.xset} r rate 160 80"
        ];
      }
      {
        name = "undocked";
        outputs_connected = [ "eDP-1" ];
        configure_single = "eDP-1";
        primary = true;
        atomic = true;
        execute_after = [
          "/run/current-system/sw/bin/systemd-run --user --on-active=5s ${lib.getExe pkgs.xorg.xset} r rate 160 80"
        ];
      }
    ];
  };

}
