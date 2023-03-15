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
  home.file.".config/eww".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/eww";

  home.packages = [
    pkgs.eww
  ];

  systemd.user.services.eww = {
    Unit = {
      Description = "Eww Daemon";
      PartOf = ["xserver-session.target"];
    };
    Service = {
      Environment = [
        "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}"
      ];
      ExecStart = "${pkgs.eww}/bin/eww daemon --no-daemonize";
      # ExecStartPost = "${config.programs.eww.package}/bin/eww open bar";
      # ExecStopPre = "${config.programs.eww.package}/bin/eww close bar";
      Restart = "on-failure";
    };
    Install.WantedBy = ["xserver-session.target"];
  };
}
