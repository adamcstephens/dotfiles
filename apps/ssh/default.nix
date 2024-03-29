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
  options.apps.ssh.tpm = lib.mkEnableOption "ssh-tpm-agent";

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

    systemd.user.services.ssh-tpm-agent = lib.mkIf cfg.tpm {
      Unit.PartOf = [ "default.target" ];

      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs.ssh-tpm-agent} -l %t/ssh-tpm-agent -A %t/ssh-agent ";
        RestartSec = 3;
        Restart = "on-abort";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
