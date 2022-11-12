{
  config,
  pkgs,
  lib,
  ...
}: let
  dependencies = with pkgs; [
    config.programs.eww.package
    bash
    bc
    bluez
    coreutils
    findutils
    gawk
    gnused
    jq
    light
    networkmanager
    playerctl
    procps
    pulseaudio
    ripgrep
    socat
    upower
    wget
    wireplumber
    wofi
  ];
in {
  programs.eww = {
    #   enable = true;
    package = pkgs.eww-wayland;
    #   configDir = ../apps/eww;
  };

  systemd.user.services.eww = {
    Unit = {
      Description = "Eww Daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
      ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
      ExecStartPost = "${config.programs.eww.package}/bin/eww open bar";
      ExecStopPre = "${config.programs.eww.package}/bin/eww close bar";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
