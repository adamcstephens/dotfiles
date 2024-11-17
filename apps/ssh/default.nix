{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.ssh;
in
{
  options.apps.ssh = {
    agent = {
      enable = lib.mkEnableOption "ssh-agent";
      askpass = lib.mkEnableOption "askpass support";
    };
    tpm = lib.mkEnableOption "ssh-tpm-agent";
  };

  config = {
    home.packages = lib.optionals cfg.tpm [ pkgs.ssh-tpm-agent ];

    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "600m";
      serverAliveInterval = 60;
      serverAliveCountMax = 2;

      # use header: # -*- mode: ssh-config -*-
      includes = [ "local.config" ];
    };

    services.ssh-agent.enable = cfg.agent.enable;

    systemd.user.services.ssh-agent = lib.mkIf cfg.agent.askpass {
      Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
      Service.Environment = [
        "SSH_ASKPASS=${pkgs.seahorse}/libexec/seahorse/ssh-askpass"
      ];
    };

    systemd.user.services.ssh-tpm-agent = lib.mkIf cfg.tpm {
      Unit = {
        PartOf = [ "graphical-session.target" ];
        After = [ "ssh-agent.service" ];
        Requires = [ "ssh-agent.service" ];
      };

      Service = {
        Type = "simple";
        Environment = [
          "SSH_ASKPASS=${pkgs.seahorse}/libexec/seahorse/ssh-askpass"
        ];
        ExecStart = "${lib.getExe pkgs.ssh-tpm-agent} -l %t/ssh-tpm-agent -A %t/ssh-agent ";
        RestartSec = 3;
        Restart = "on-abort";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
